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
  const barStart = 70;
  const formatValue = d3.format('.0f');

  g.selectAll('rect')
    .data(data)
    .join(
      enter => enter.append('rect')
        .attr('x', 0) 
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

    g.selectAll('text.category-label')
    .data(data)
    .append('text')
    .attr('class', 'category-label')
    .attr('x', 10) 
    .attr('y', d => yScale(d.category) + yScale.bandwidth() / 2)
    .attr('dy', '0.35em')
    .attr('font-size', '1rem')
    .attr('fill', 'black')
    .attr('text-anchor', 'start')
    .text(d => props.layerPaths[d.category]?.label || d.category)


  // update labels
  g.selectAll('text.value-label')
    .data(data)
    .join(
      enter => enter.append('text')
      .attr('class', 'value-label')
        .attr('x', d => xScale(d.total) + 5) // position to the right of the bar
        .attr('y', d => yScale(d.category) + yScale.bandwidth() / 2) // center vertically
        .attr('dy', '0.35em')
        .attr('font-size', '1rem')
        .attr('fill', 'black')
        .attr('text-anchor', 'start')
        .text(d => d3.format(',')(formatValue(d.total))),
      update => update.transition().duration(750)
        .attr('x', d => xScale(d.total) + 5)
        .attr('y', d => yScale(d.category) + yScale.bandwidth() / 2)
        .text(d => d3.format(',')(formatValue(d.total))),
      exit => exit.transition().duration(750).attr('x', 0).remove()
    );

  // update y-axis labels
  const yAxis = d3.axisLeft(yScale).tickSize(0).tickPadding(5)
  svg.select('.y-axis').attr('transform', `translate(${barStart}, 0)`).call(yAxis);

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
    .attr('viewBox', `0 0 800 150`)
    .attr('preserveAspectRatio', 'xMidYMid meet')
    .classed('bar-chart-svg', true);

  svg.append('g').attr('class', 'y-axis').attr('transform', 'translate(0, 0)');
  svg.append('g'); // append main g for bars
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
  