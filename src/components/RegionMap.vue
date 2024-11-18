<template>
    <div class="text-container">
      <div ref="barContainer" class="bar-container"></div>
    </div>
    <div ref="mapContainer" class="map-container"></div>
  </template>
  
  <script setup>
  import { onMounted, ref } from 'vue'
  import * as d3 from 'd3'
  import * as topojson from 'topojson-client'
  
  const mapContainer = ref(null)
  const barContainer = ref(null)
  
  onMounted(async () => {
    if (!mapContainer.value) {
      console.error('mapContainer is not defined')
      return
    }
  
    const width = 750;
    const height = 600;
    const cropTop = 0;
    const cropBottom = 0;
    const maxHeight = 700;
  
    // create svg that holds the map
    const svg = d3.select(mapContainer.value)
      .append('svg')
      .attr('viewBox', `0 0 ${width} ${height}`)
      .attr('preserveAspectRatio', 'xMidYMid meet')
      .classed('responsive-svg', true);
  
    // resizing so flexes to page width but stays within reasonable height
    const resizeSvg = () => {
      const containerWidth = mapContainer.value.clientWidth;
      const containerHeight = Math.min(mapContainer.value.clientHeight, maxHeight);
      svg.attr('width', containerWidth).attr('height', containerHeight);
    };
  
    resizeSvg();
    window.addEventListener('resize', resizeSvg);
  
    // svg for stacked bar chart
    const svgBar = d3.select(barContainer.value)
      .append('svg')
      .attr('viewBox', `0 0 700 100`)
      .attr('preserveAspectRatio', 'xMidYMid meet')
      .classed('bar-chart-svg', true);
  
    let activeRegion = null; // start at national scale
    const g = svgBar.append('g'); // Bar chart container
  
    // updating stacked bar chart to selected region or state
    const updateBarChart = (data, regionName = 'United States') => {
      if (!data.length) return;
  
      const categories = data.map(d => d.sui_category_5);
      const values = data.map(d => +d.percentage_stress);
      const colors = d3.scaleOrdinal()
        .domain(categories)
        .range(['#965a6b', '#Cfacab', '#edeadf', '#80909D', '#39424f']);
  
      const xScale = d3.scaleLinear()
        .domain([0, d3.sum(values)])
        .range([0, 700]);
  
      g.selectAll('rect')
        .data(data)
        .join(
        enter => enter.append('rect')
            .attr('x', (d, i) => xScale(d3.sum(values.slice(0, i))))
            .attr('y', 0)
            .attr('width', 0) 
            .attr('height', 30)
            .attr('fill', d => colors(d.sui_category_5))
            .call(enter => enter.transition()
            .duration(750) 
            .attr('width', d => xScale(d.percentage_stress))),
        update => update
            .call(update => update.transition()
            .duration(750)
            .attr('x', (d, i) => xScale(d3.sum(values.slice(0, i))))
            .attrTween('width', function(d, i) {
                const previousWidth = d3.select(this).attr('width') || 0; // fallback to 0 if no prior value
                const interpolator = d3.interpolate(previousWidth, xScale(d.percentage_stress));
                return t => interpolator(t);
            })),
        exit => exit
            .call(exit => exit.transition()
            .duration(750)
            .attr('width', 0) 
            .remove())
        );
 // updating chart title with region name
  g.selectAll('text.chart-title')
    .data([regionName])
    .join(
      enter => enter.append('text')
        .attr('class', 'chart-title')
        .attr('x', 0)
        .attr('y', -10)
        .attr('fill', 'black')
        .attr('font-size', '2.5rem')
        .text(regionName),
      update => update.call(update => update.transition()
        .duration(750)
        .text(regionName))
    );
  
      const formatPercentage = d3.format('.0f');
  
      // percent labels on bar chart - currently overlap where very small
      g.selectAll('.chart-labels')
      .data(data, d => d.sui_category_5) // key by sui_category_5
      .join(
        enter => enter.append('text')
          .attr('class', 'chart-labels')
          .attr('x', (d, i) => xScale(d3.sum(values.slice(0, i)) + d.percentage_stress / 2))
          .attr('y', 50)
          .attr('fill', 'black')
          .attr('text-anchor', 'middle')
          .text(d => `${formatPercentage(d.percentage_stress)}%`)
          .style('opacity', 0)
          .call(enter => enter.transition()
            .duration(750)
            .style('opacity', 1)),
        update => update
          .call(update => update.transition()
            .duration(750)
            .attr('x', (d, i) => xScale(d3.sum(values.slice(0, i)) + d.percentage_stress / 2))
            .text(d => `${formatPercentage(d.percentage_stress)}%`)),
        exit => exit
          .call(exit => exit.transition()
            .duration(750)
            .style('opacity', 0)
            .remove())
      );
    };
  
    try {
        // read in data
      const topoData = await d3.json(import.meta.env.BASE_URL + '/assets/Regions.topojson');
      const geoData = topojson.feature(topoData, topoData.objects[Object.keys(topoData.objects)[0]]);
      const csvData = await d3.csv(import.meta.env.BASE_URL + '/wa_stress_stats.csv');
  
      const projection = d3.geoIdentity().reflectY(true).fitSize([width, height], geoData);
      const path = d3.geoPath().projection(projection);
  
      // Overlay the raster image
      const scale_size = 1.1; // scaling pngs because they have an added margin when exported from ggplot
      svg.append('g')
        .append('image')
        .attr('xlink:href', import.meta.env.BASE_URL + '/assets/01_stress_map.png')
        .attr('x', -38) // nudging png to fit within svg bounds
        .attr('y', -30) // nudging png to fit within svg bounds
        .attr('width', width * scale_size)
        .attr('height', height * scale_size);
  
      const totalByCategory = d3.rollups(
        csvData,
        v => d3.sum(v, d => +d.stress_by_reg),
        d => d.sui_category_5
      );
  
      const totalStress = d3.sum(totalByCategory, d => d[1]);
  
      const aggregatedData = totalByCategory.map(([category, value]) => ({
        sui_category_5: category,
        percentage_stress: (value / totalStress) * 100,
      }));
  
      updateBarChart(aggregatedData, 'United States');
  
      const paths = svg.append('g')
        .selectAll('path')
        .data(geoData.features)
        .join('path')
        .attr('d', path)
        .attr('class', d => `region-${d.properties.Region_nam_nospace}`)
        .attr('fill', 'transparent')
        .attr('stroke', 'white')
        .attr('stroke-width', '2px')
        .on('mouseover', highlightRegionAndUpdateChart)
        .on('mouseout', function (event, d) {
          if (activeRegion !== d.properties.Region_nam_nospace) {
            d3.select(this)
            .attr('stroke', 'white')
            .attr('stroke-width', '2px'); // Restore primary path
          d3.select(`.region ${d.properties.Region_nam_nospace}`)
            .attr('stroke', 'grey')
            .attr('stroke-width', '0.65px'); // Restore secondary path
          }
          activeRegion = null;
          updateBarChart(aggregatedData, 'United States');
        })
        .on('click', (event, d) => {
          activeRegion = d.properties.Region_nam_nospace;
          highlightRegionAndUpdateChart(event, d);
        });
  
      function highlightRegionAndUpdateChart(event, d) {
        if (activeRegion !== d.properties.Region_nam_nospace) {
          d3.select(event.target).attr('stroke', 'black')
          .attr('stroke-width', '2px')
          .raise();
        }
  
        const regionClassFilter = d.properties.Region_nam;
        const filteredData = csvData
          .filter(row => row.Region_nam === regionClassFilter)
          .map(row => ({
            sui_category_5: row.sui_category_5,
            percentage_stress: (+row.stress_by_reg / d3.sum(csvData.filter(r => r.Region_nam === regionClassFilter), r => +r.stress_by_reg)) * 100,
          }));
  
        updateBarChart(filteredData, `${regionClassFilter} region`);
      }

      svg.append('g')
        .selectAll('path')
        .data(geoData.features)
        .join('path')
        .attr('d', path)
        .attr('fill', 'none')
        .attr('stroke', 'grey')
        .attr('stroke-width', '0.65px');
  
    } catch (error) {
      console.error('Error loading TopoJSON:', error);
    }
  });
  </script>
  
  <style>
  .map-container {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    height: auto;
    max-height: 700px;
  }
  
  .responsive-svg {
    width: 100%;
    height: auto;
    max-height: 100%;
  }
  
  .bar-chart-svg {
    width: 100%;
    height: auto;
    max-height: 100%;
  }
  </style>
  