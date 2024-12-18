<template>
    <div class="map-and-chart">
      <div ref="mapContainer" class="map-container"></div>
      <StackedBarChart
        :categoricalVariable="categoricalVariable"
        :continuousPercent="continuousPercent"
        :layerPaths="layerPaths"
        :regionData="activeRegionData"
        :regionName="activeRegionName"
      />
    </div>
  </template>
  
  <script setup>
  import { onMounted, ref, watch } from 'vue';
  import * as d3 from 'd3';
  import * as topojson from 'topojson-client';
  import StackedBarChart from './StackedBarChart.vue';
  
  const mapContainer = ref(null);
  const activeRegionData = ref([]);
  const activeRegionName = ref('United States');
  let mapLayers;
  let aggregatedDataCache = null;
  
  const props = defineProps({
    layerVisibility: Object,
    layerPaths: Object,
    regionsDataUrl: String,
    regionsVar: String,
    usOutlineUrl: String,
    csvDataUrl: String,
    continuousRaw: String,
    continuousPercent: String,
    categoricalVariable: String,
  });
  
  const updateLayers = () => {
    if (!mapLayers) return;
  
    const visibleLayers = Object.entries(props.layerVisibility).map(([key, value]) => ({
      key,
      path: props.layerPaths[key]?.path,
      visible: value,
    }));
  
    mapLayers.selectAll('image')
      .data(visibleLayers, d => d.key)
      .join(
        enter => enter.append('image')
          .attr('xlink:href', d => `https://labs.waterdata.usgs.gov/visualizations/images/water-availability/${d.path}`)
          .attr('x', -80)
          .attr('y', -55)
          .attr('width', 800 * 1.2)
          .attr('height', 550 * 1.2)
          .style('opacity', d => (d.visible ? 1 : 0))
          .style('display', d => (d.visible ? 'block' : 'none')),
        update => update
          .style('opacity', d => (d.visible ? 1 : 0))
          .style('display', d => (d.visible ? 'block' : 'none')),
        exit => exit.remove()
      );
  };
  
  watch(
    () => props.layerVisibility,
    () => updateLayers(),
    { deep: true }
  );
  
  onMounted(async () => {
    const width = 800;
    const height = 550;
  
    const svg = d3.select(mapContainer.value)
      .append('svg')
      .attr('viewBox', `0 0 ${width} ${height}`)
      .attr('preserveAspectRatio', 'xMidYMid meet')
      .classed('responsive-svg', true);
  
    mapLayers = svg.append('g').attr('class', 'map-layers');
    updateLayers();
  
    try {
    const topoRegions = await d3.json(props.regionsDataUrl);
    const geoRegions = topojson.feature(topoRegions, topoRegions.objects[Object.keys(topoRegions.objects)[0]]);
    const topoUS = await d3.json(props.usOutlineUrl);
    const geoUS = topojson.feature(topoUS, topoUS.objects['foo']);
    const csvData = await d3.csv(props.csvDataUrl);

    const projection = d3.geoIdentity().reflectY(true).fitSize([width, height], geoRegions);
    const path = d3.geoPath().projection(projection);

    // Precompute aggregated data for national scale
    aggregatedDataCache = d3.rollups(
      csvData,
      v => d3.sum(v, d => +d[props.continuousRaw]),
      d => d[props.categoricalVariable]
    ).map(([category, value]) => ({
      [props.categoricalVariable]: category,
      [props.continuousPercent]: (value / d3.sum(csvData, d => +d[props.continuousRaw])) * 100,
    }));

    activeRegionData.value = aggregatedDataCache;

    // Add CONUS outline
    svg.append('g')
      .append('path')
      .datum(geoUS)
      .attr('class', 'outline-conus')
      .attr('d', path)
      .attr('fill', 'none')
      .attr('stroke', 'grey')
      .attr('stroke-width', '2px');

      svg.append('g')
        .selectAll('path')
        .data(geoRegions.features)
        .join('path')
        .attr('d', path)
        .attr('fill', 'none')
        .attr('stroke', 'white')
        .attr('stroke-width', '0.75px');

    // Add interactive regions
    svg.append('g')
      .selectAll('path')
      .data(geoRegions.features)
      .join('path')
      .attr('d', path)
      .attr('class', d => `region ${d.properties[props.regionsVar]}`)
      .attr('fill', 'transparent')
      .attr('stroke', 'white')
      .attr('stroke-width', '0.5px')
      .on('mouseover', function (event, d) {
        // Highlight hovered region and dim others
        d3.selectAll('.region')
          .attr('fill', 'lightgrey')
          .attr('opacity', 0.8);

        d3.select(this)
          .attr('fill', 'transparent')
          .attr('opacity', 1)
          .attr('stroke', 'white')
          .attr('stroke-width', '1.5px')
          .raise();

        // Filter data for hovered region
        const regionName = d.properties[props.regionsVar];
        const filteredData = csvData
          .filter(row => row[props.regionsVar] === regionName)
          .map(row => ({
            [props.categoricalVariable]: row[props.categoricalVariable],
            [props.continuousPercent]: (+row[props.continuousRaw] / d3.sum(
              csvData.filter(r => r[props.regionsVar] === regionName),
              r => +r[props.continuousRaw]
            )) * 100,
          }));

        activeRegionName.value = `${regionName} Region`;
        activeRegionData.value = filteredData;
      })
      .on('mouseout', () => {
        // Reset to national data
        d3.selectAll('.region')
          .attr('fill', 'transparent')
          .attr('opacity', 0)
          .attr('stroke', 'white')
          .attr('stroke-width', '1px');

        activeRegionName.value = 'United States';
        activeRegionData.value = aggregatedDataCache;
      });
  } catch (error) {
    console.error('Error loading data:', error);
  }
});
  </script>
  
  <style>
  .map-and-chart {
    display: flex;
    flex-direction: column;
    align-items: center;
  }
  .map-container {
    width: 100%;
    height: auto;
  }
  .responsive-svg {
    width: 100%;
    height: auto;
  }
  .outline-conus {
  filter: drop-shadow(0px 0px 10px rgba(2, 2, 2, 0.5));
}
  </style>
  