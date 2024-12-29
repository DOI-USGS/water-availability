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
  
  // render legend initially and watch for changes
  onMounted(() => {
    initLegend(props.data);
    });
    
    watch(
  () => [props.data, props.regionName],
  ([newData]) => {
    if (!svg) {
      initLegend(newData); // Initialize if SVG doesn't exist
    } else {
      updateLegend(newData); // Update existing legend
    }
  },
  { deep: true }
);


// Initialize Legend
function initLegend(data) {
  const { colors } = props.layerPaths;

  // Sort data
  const sortedData = processData(data);

  // Dimensions
  const width = 700;
  const height = 100;
  const rectHeight = 70;
  const marginTop = 20;

  svg = d3.select(legendSvg.value)
    .attr('width', width)
    .attr('height', height);

  const xScale = d3.scaleBand()
    .domain(sortedData.map(d => d.category))
    .range([0, width - 20])
    .padding(0.1);

  const yScale = d3.scaleLinear()
    .domain([0, d3.max(sortedData, d => d.value)])
    .range([0, rectHeight]);

  // Bars
  svg.selectAll('rect')
    .data(sortedData)
    .enter()
    .append('rect')
    .attr('x', d => xScale(d.category))
    .attr('y', d => rectHeight - yScale(d.value))
    .attr('width', xScale.bandwidth())
    .attr('height', d => yScale(d.value))
    .style('fill', (d, i) => colors[i % colors.length]);

  // Labels
  svg.selectAll('text')
    .data(sortedData)
    .enter()
    .append('text')
    .attr('x', d => xScale(d.category) + xScale.bandwidth() / 2)
    .attr('y', rectHeight + marginTop)
    .attr('text-anchor', 'middle')
    .style('font-size', '12px')
    .text(d => d.category);
}

// Update Legend
function updateLegend(data, region) {
  const sortedData = processData(data);
  const rectHeight = 70;

  const { colors } = props.layerPaths;

  const xScale = d3.scaleBand()
    .domain(sortedData.map(d => d.category))
    .range([0, 700 - 20])
    .padding(0.1);

  const yScale = d3.scaleLinear()
    .domain([0, d3.max(sortedData, d => d.value)])
    .range([0, rectHeight]);

  svg.selectAll('rect')
    .data(sortedData)
    .transition()
    .duration(750)
    .attr('y', d => rectHeight - yScale(d.value))
    .attr('height', d => yScale(d.value))
    .style('fill', (d, i) => colors[i % colors.length]);

  svg.selectAll('text')
    .data(sortedData)
    .transition()
    .duration(750)
    .text(d => d.category);
}

// Helper Function to Process Data
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
