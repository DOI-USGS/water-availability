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
  const svgContainer = d3.select(legendSvg.value);
  svgContainer.selectAll('*').remove();

  const { breaks, colors } = props.layerPaths;

  // validate inputs
  if (!breaks || !colors || breaks.length !== colors.length + 1) {
    console.warn('Invalid breaks or colors configuration');
    return;
  }

  // svg dimensions
  const width = 700;
  const height = 50;
  const rectHeight = 10;

  const svg = svgContainer
    .attr('width', width)
    .attr('height', height);

  // calculate width of each rectangle based on breaks
  const rectWidth = width / (breaks.length - 3);

  // add rectangles for legend colors
  svg.selectAll('rect')
    .data(colors)
    .enter()
    .append('rect')
    .attr('x', (d, i) => i * rectWidth+50) // position based on index
    .attr('y', 20) // vertical position
    .attr('width', rectWidth) // uniform width
    .attr('height', rectHeight) // fixed height
    .style('fill', d => d);

  // add labels for breaks
  svg.selectAll('text')
    .data(breaks)
    .enter()
    .append('text')
    .attr('x', (d, i) => i * rectWidth+50) // align with rectangles
    .attr('y', 45) // below the rectangles
    .attr('text-anchor', i => (i === breaks.length - 1 ? 'end' : 'middle')) // align labels
    .style('font-size', '12px')
    .text((d, i) =>  i === breaks.length - 1  ? '>' + breaks[i - 1]  : d ); // custom label for last break
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