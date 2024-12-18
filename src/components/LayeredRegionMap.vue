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
  
    const topoRegions = await d3.json(props.regionsDataUrl);
    const geoRegions = topojson.feature(topoRegions, topoRegions.objects[Object.keys(topoRegions.objects)[0]]);
    const csvData = await d3.csv(props.csvDataUrl);
  
    const projection = d3.geoIdentity().reflectY(true).fitSize([width, height], geoRegions);
    const path = d3.geoPath().projection(projection);
  
    const aggregatedData = d3.rollups(
      csvData,
      v => d3.sum(v, d => +d[props.continuousRaw]),
      d => d[props.categoricalVariable]
    ).map(([category, value]) => ({
      [props.categoricalVariable]: category,
      [props.continuousPercent]: (value / d3.sum(csvData, d => +d[props.continuousRaw])) * 100,
    }));
  
    activeRegionData.value = aggregatedData;
  
    svg.append('g')
      .selectAll('path')
      .data(geoRegions.features)
      .join('path')
      .attr('d', path)
      .attr('class', d => `region ${d.properties[props.regionsVar]}`)
      .attr('fill', 'transparent')
      .attr('stroke', 'white')
      .attr('stroke-width', '1px')
      .on('mouseover', (event, d) => {
        const regionName = d.properties[props.regionsVar];
        const filteredData = csvData
          .filter(row => row[props.regionsVar] === regionName)
          .map(row => ({
            [props.categoricalVariable]: row[props.categoricalVariable],
            [props.continuousPercent]: (+row[props.continuousRaw] / d3.sum(csvData.filter(r => r[props.regionsVar] === regionName), r => +r[props.continuousRaw])) * 100,
          }));
  
        activeRegionName.value = `${regionName} Region`;
        activeRegionData.value = filteredData;
      })
      .on('mouseout', () => {
        activeRegionName.value = 'United States';
        activeRegionData.value = aggregatedData;
      });
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
  </style>
  