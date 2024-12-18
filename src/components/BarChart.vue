<template>
    <div ref="barContainer" class="bar-container"></div>
  </template>
  
  <script setup>
  import { onMounted, ref, watch } from 'vue';
  import * as d3 from 'd3';
  
  const barContainer = ref(null);
  const xMax = 120000;
  const props = defineProps({
    categoricalVariable: String,
    continuousRaw: String,
    layerPaths: Object,
    regionData: {
      type: Array,
      required: true,
    },
    regionName: {
      type: String,
      default: 'United States',
    },
  });
  
  const updateBarChart = (data, regionName) => {
  if (!data || data.length === 0) {
    console.warn('No data provided for the bar chart.');
    return;
  }

  const svg = d3.select(barContainer.value).select('svg');
  const g = svg.select('g');

  const xScale = d3.scaleLinear()
    .domain([0, xMax]) 
    .range([0, 600]); 

  const yScale = d3.scaleBand()
    .domain(data.map(d => d.category)) 
    .range([0, data.length * 16]) // adjust height of bars and spacing
    .padding(0.5);

  const getColor = category => {
    const normalizedCategory = category.trim().toLowerCase().replace(/[\s/\\]+/g, '_');
    return props.layerPaths[normalizedCategory]?.color || '#ccc';
  };

  // update bars
  const barStart = 150;
  g.selectAll('rect')
    .data(data)
    .join(
      enter => enter.append('rect')
        .attr('x', barStart) 
        .attr('y', d => yScale(d.category)) // vertical positioning
        .attr('height', yScale.bandwidth()) 
        .attr('fill', d => getColor(d.category)) 
        .attr('width', 0) // start with width 0
        .transition().duration(750)
        .attr('width', d => xScale(d.total)), // grow to full width
      update => update.transition().duration(750)
        .attr('y', d => yScale(d.category))
        .attr('width', d => xScale(d.total)),
      exit => exit.transition().duration(750).attr('width', 0).remove()
    );

  // update labels
  g.selectAll('text')
    .data(data)
    .join(
      enter => enter.append('text')
        .attr('x', d => xScale(d.total) + 5 + barStart) // position to the right of the bar
        .attr('y', d => yScale(d.category) + yScale.bandwidth() / 2) // center vertically
        .attr('dy', '0.35em')
        .attr('font-size', '1rem')
        .attr('fill', 'black')
        .attr('text-anchor', 'start')
        .text(d => d3.format(',')(d.total)),
      update => update.transition().duration(750)
        .attr('x', d => xScale(d.total) + 5 + barStart)
        .attr('y', d => yScale(d.category) + yScale.bandwidth() / 2)
        .text(d => d3.format(',')(d.total)),
      exit => exit.transition().duration(750).attr('x', 0).remove()
    );

  // update y-axis labels
  const yAxis = d3.axisLeft(yScale).tickSize(0).tickPadding(5)
  svg.select('.y-axis').call(yAxis);

  // style y-axis labels
  svg.select('.y-axis').selectAll('text')
    .attr('font-size', '1rem')
    .attr('fill', 'black');
};

// watch for changes in regionData and regionName
watch(
  () => [props.regionData, props.regionName],
  ([newData, newRegionName]) => {
    updateBarChart(newData, newRegionName);
  },
  { immediate: true }
);

onMounted(() => {
  const svg = d3.select(barContainer.value).append('svg')
    .attr('viewBox', `0 0 800 ${props.regionData.length * 20 + 50}`) // adjust height dynamically
    .attr('preserveAspectRatio', 'xMidYMid meet')
    .classed('bar-chart-svg', true);

  svg.append('g').attr('class', 'y-axis').attr('transform', 'translate(0, 0)');
  svg.append('g'); // append main g for bars
});

  
  // watch for changes in regionData and regionName
  watch(
    () => [props.regionData, props.regionName],
    ([newData, newRegionName]) => {
      updateBarChart(newData, newRegionName);
    },
    { immediate: true }
  );
  
  onMounted(() => {
    // create svg container
    const svg = d3.select(barContainer.value).append('svg')
      .attr('viewBox', `0 0 800 ${props.regionData.length * 40 + 50}`)
      .attr('preserveAspectRatio', 'xMidYMid meet')
      .classed('bar-chart-svg', true);
  
    svg.append('g').attr('class', 'y-axis').attr('transform', 'translate(0, 0)');
    svg.append('g').attr('transform', 'translate(0, 10)'); // append g element
  });
  </script>
  
  <style>
  .bar-container {
    width: 100%;
    height: auto;
    overflow: visible;
  }
  
  .bar-chart-svg {
    width: 100%;
    height: auto;
    min-height: 100px;
  }
  </style>
  