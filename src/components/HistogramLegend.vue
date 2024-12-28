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
    },
    data: { 
      type: Array, 
      required: true // expects histogram data
    }
  });
  
  const legendSvg = ref(null);
  
  // render legend initially and watch for changes
  onMounted(renderLegend);
  
  // watch all relevant props for updates
  watch(
    () => [props.layerPaths, props.data],
    renderLegend,
    { deep: true }
  );
  
  // render legend
  function renderLegend() {
    // clear existing legend
    d3.select(legendSvg.value).selectAll('*').remove();
  
    const { breaks, colors } = props.layerPaths;
  
    // validate input
    if (!breaks || !colors || breaks.length !== colors.length + 1) {
      console.warn('Invalid breaks or colors configuration:', breaks, colors);
      return;
    }

    // sort the binned groups based on the first number in the labels
    const sortedData = props.data
        .map(d => {
            const numericValue = d.category.match(/\d+/); // find first number, strip symbols
            return { ...d, numericValue }; 
        })
        .sort((a, b) => a.numericValue - b.numericValue); // and sort 

  
    // dimensions
    const width = 700;
    const height = 100;
    const rectHeight = 70;
    const marginTop = 20;
  
    const svg = d3.select(legendSvg.value)
      .attr('width', width)
      .attr('height', height);

    // x scale for breaks
    const xScale = d3.scaleBand()
        //.domain(breaks.map((_, i) => i)) // indexes for bars
        .domain(sortedData.map(d => d.category))
        .range([0, width - 20])
        .padding(0.1);

    // y scale for heights
    const yScale = d3.scaleLinear()
        .domain([0, 1])//d3.max(sortedData, d => d.value)]) // scale based on max height
        .range([0, rectHeight]);

    // draw histogram bars
    svg.selectAll('rect')
        .data(sortedData)
        .enter()
        .append('rect')
        .attr('x', (d) => xScale(d.category))
        .attr('y', d => rectHeight - yScale(d.value)) // scale heights
        .attr('width', xScale.bandwidth())
        .attr('height', d => yScale(d.value))
        .style('fill', (d, i) => colors[i]);

    // draw bin labels
    svg.selectAll('text')
        .data(props.data)
        .enter()
        .append('text')
        //.attr('x', (_, i) => xScale(i) + xScale.bandwidth() / 2) // center align
        .attr('x', d => xScale(d.category) + xScale.bandwidth() / 2)
        .attr('y', rectHeight + marginTop) // position below bars
        .attr('text-anchor', 'middle')
        .style('font-size', '12px')
        .text(d => d.category)
        //.text((d, i) => (i === breaks.length - 1 ? `>${breaks[i - 1]}` : d)); // label last bin as '>'
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
  