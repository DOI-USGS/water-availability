<template>
    <div class="legend-container">
      <svg ref="legendSvg" class="legend-svg"></svg>
    </div>
  </template>
  
  <script setup>
  import { onMounted, ref, defineProps, watch } from 'vue';
  import * as d3 from 'd3';
  
  // define props
  const props = defineProps({
    layerPaths: { 
      type: Object, 
      required: true // expects breaks and colors
    }
  });
  
  const legendSvg = ref(null);
  
  // render legend on mount and update
  onMounted(renderLegend);

  // watch breaks and colors specifically
    watch(
    () => [props.layerPaths.breaks, props.layerPaths.colors],
    renderLegend,
    { deep: true }
    );

  function renderLegend() {
    // remove any existing legend
    d3.select(legendSvg.value).selectAll('*').remove();
  
    const { breaks, colors } = props.layerPaths;
    if (!breaks || !colors || breaks.length !== colors.length) {
      console.warn('Invalid breaks or colors configuration');
      return;
    }
  
    const width = 400;
    const height = 50;
    const rectHeight = 20;
  
    const svg = d3.select(legendSvg.value)
      .attr('width', width)
      .attr('height', height);
  
    // create scale for positioning
    const xScale = d3.scaleLinear()
      .domain([breaks[0], breaks[breaks.length - 1]])
      .range([0, width - 20]);
  
    // add rectangles for legend colors
    svg.selectAll('rect')
      .data(colors)
      .enter()
      .append('rect')
      .attr('x', (d, i) => xScale(breaks[i]))
      .attr('y', 10)
      .attr('width', (d, i) => i < breaks.length - 1 ? xScale(breaks[i + 1]) - xScale(breaks[i]) : 0)
      .attr('height', rectHeight)
      .style('fill', d => d);
  
    // add labels for breaks
    svg.selectAll('text')
      .data(breaks)
      .enter()
      .append('text')
      .attr('x', d => xScale(d))
      .attr('y', 45)
      .attr('text-anchor', 'middle')
      .style('font-size', '12px')
      .text(d => d);
  }
  </script>
  
  <style scoped>
  .legend-container {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    padding: 10px 0;
  }
  .legend-svg {
    width: 100%;
    height: auto;
  }
  </style>
  