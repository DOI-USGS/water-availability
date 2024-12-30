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
    },
    regionName: { 
        type: String, 
        default: 'United States',
        require: true
    },
  });
  
  const legendSvg = ref(null);
  let svg;
  
  // chart dimensions
  const width = 700;
  const height = 100;
  const rectHeight = 70;
  const marginTop = 20;


  // render legend initially and watch for changes
  onMounted(() => {
    setupSVG();
    updateLegend(props.data);
    });
    
    // Watch for updates in data or region name
watch(
  () => [props.data, props.regionName],
  ([newData, newRegion]) => {
    initLegend(newData, newRegion);
  },
  { deep: true }
);

// create svg only once
function setupSVG() {
  svg = d3.select(legendSvg.value)
    .attr('width', width)
    .attr('height', height);
}

// Initialize Legend
function initLegend(data) {
  console.log('Input Data:', data);
  const { colors } = props.layerPaths;

  // Sort data
  const sortedData = processData(data);
  console.log('Processed Data:', sortedData);


  const colorScale = d3.scaleOrdinal()
    .domain(sortedData.map(d => d.category))
    .range(colors)

  const xScale = d3.scaleBand()
    .domain(sortedData.map(d => d.category))
    .range([0, width - 20])
    .padding(0.1);

  const yScale = d3.scaleLinear()
    .domain([0, 1])
    .range([0, rectHeight]);

  // Bars
  svg.selectAll('rect')
    .data(sortedData)
    .join('rect')
    .attr('x', d => xScale(d.category))
    .attr('y', d => rectHeight - yScale(d.value))
    .attr('width', xScale.bandwidth())
    .attr('height', d => yScale(d.value))
    .style('fill', d => colorScale(d.category));

  // Labels
  svg.selectAll('text')
    .data(sortedData)
    .join('text')
    .attr('x', d => xScale(d.category) + xScale.bandwidth() / 2)
    .attr('y', rectHeight + marginTop)
    .attr('text-anchor', 'middle')
    .style('font-size', '12px')
    .text(d => d.category);
}

// Update Legend
function updateLegend(data) {
  
  const { colors } = props.layerPaths;
  const sortedData = processData(data);

  const xScale = d3.scaleBand()
    .domain(sortedData.map(d => d.category))
    .range([0, width - 20])
    .padding(0.1);

  const yScale = d3.scaleLinear()
    .domain([0, 1])
    .range([0, rectHeight]);

  const colorScale = d3.scaleOrdinal()
    .domain(sortedData.map(d => d.category))
    .range(colors)

  svg.selectAll('rect')
    .data(sortedData)
    .transition()
    .duration(500)
    .attr('y', d => rectHeight - yScale(d.value))
    .attr('height', d => yScale(d.value))
    .style('fill', d => colorScale(d.category));

  svg.selectAll('text')
    .data(sortedData)
    .transition()
    .duration(750)
    .text(d => d.category);
}

// Process Data
function processData(data) {
  return data
    .map(d => {
      // Validate and handle missing or invalid 'category' field
      const category = d.category && typeof d.category === 'string' ? d.category : '0';
      return {
        ...d,
        numericValue: parseFloat(category.match(/\d+/)) || 0 // Extract number or default to 0
      };
    })
    .sort((a, b) => a.numericValue - b.numericValue);
}

</script>
<style scoped>
.legend-container {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 10px;
}
.legend-svg {
  width: 100%;
  height: auto;
}
</style>