<template>
  <div ref="barContainer" class="bar-container"></div>
</template>

<script setup>
import { onMounted, ref, watch } from 'vue';
import * as d3 from 'd3';

const barContainer = ref(null);

const props = defineProps({
  categoricalVariable: String,
  continuousPercent: String,
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
    .domain([0, d3.sum(data, d => +d[props.continuousPercent])])
    .range([0, 700]);

  const getColor = category => {
    const normalizedCategory = category.trim().toLowerCase().replace(/[\s/\\]+/g, '_');
    return props.layerPaths[normalizedCategory]?.color || '#ccc';
  };

  const formatPercentage = d3.format('.0f');

  // update bars
  g.selectAll('rect')
    .data(data)
    .join(
      enter => enter.append('rect')
        .attr('x', (d, i) => xScale(d3.sum(data.slice(0, i), d => +d[props.continuousPercent])))
        .attr('y', 0)
        .attr('height', 30)
        .attr('fill', d => getColor(d[props.categoricalVariable]))
        .attr('width', 0) // start with width 0
        .transition().duration(750)
        .attr('width', d => xScale(+d[props.continuousPercent])),
      update => update.transition().duration(750)
        .attr('x', (d, i) => xScale(d3.sum(data.slice(0, i), d => +d[props.continuousPercent])))
        .attr('width', d => xScale(+d[props.continuousPercent])),
      exit => exit.transition().duration(750).attr('width', 0).remove()
    );

  // update labels
  g.selectAll('text.chart-labels')
    .data(data)
    .join(
      enter => enter.append('text')
        .attr('class', 'chart-labels')
        .attr('x', (d, i) => xScale(d3.sum(data.slice(0, i), d => +d[props.continuousPercent]) + d[props.continuousPercent] / 2))
        .attr('y', 45)
        .attr('font-size','1.8rem')
        .attr('fill', 'black')
        .attr('text-anchor', 'middle')
        .text(d => `${formatPercentage(d[props.continuousPercent])}%`)
        .style('opacity', d => (d[props.continuousPercent] < 1 ? 0 : 1 )) 
        .transition().duration(750)
        .style('opacity', d => (d[props.continuousPercent] < 1 ? 0 : 1 )),
      update => update.transition().duration(750)
        .attr('x', (d, i) => xScale(d3.sum(data.slice(0, i), d => +d[props.continuousPercent]) + d[props.continuousPercent] / 2))
        .text(d => `${formatPercentage(d[props.continuousPercent])}%`)
        .style('opacity', d => (d[props.continuousPercent] < 1 ? 0 : 1 )) ,
      exit => exit.transition().duration(750).style('opacity', 0).remove() // fade out and remove
    );

  // clean and update chart title
  const cleanRegionName = regionName.replace(/_/g, ' ');

  // update chart title
  g.selectAll('text.chart-title')
    .data([regionName])
    .join('text')
    .attr('class', 'chart-title')
    .attr('x', 0)
    .attr('y', -10)
    .attr('font-size', '2.2rem')
    .attr('font-weight', 'bold')
    .text(cleanRegionName);
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
  // create svg container
  const svg = d3.select(barContainer.value).append('svg')
    .attr('viewBox', '0 -30 700 100')
    .attr('preserveAspectRatio', 'xMidYMid meet')
    .classed('bar-chart-svg', true);

  svg.append('g'); // append g element
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
  height: 100px;
}
</style>
