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
  const { colors } = props.layerPaths;

  // Sort data
  const sortedData = processData(data);

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
    .data(sortedData, d => d.category)
    .join('rect')
    .attr('x', d => xScale(d.category))
    .attr('y', d => rectHeight - yScale(d.value))
    .attr('width', xScale.bandwidth())
    .attr('height', d => yScale(d.value))
    .style('fill', d => colorScale(d.category));

  // Labels
  svg.selectAll('text')
    .data(sortedData, d => d.category)
    .join('text')
    .attr('x', d => xScale(d.category) + xScale.bandwidth() / 2)
    .attr('y', rectHeight + marginTop)
    .attr('text-anchor', 'middle')
    .style('font-size', '12px')
    .text(d => d.category);

  const displayTitle = props.regionName === 'United States' ? props.regionName : `${props.regionName} Region`;

  svg.selectAll('text')
    .data(props.regionName)
    .join(
      enter => enter.append('text')
        .attr('class', 'chart-title')
        .attr('x', 10)
        .attr('y', 30)
        .attr('color', 'black')
        .attr('font-size', '2.25rem')
        .attr('font-weight', 'bold')
        .text(displayTitle))
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
    .data(sortedData, d => d.category)
    .join(
      enter => enter.append('rect')
        .attr('y', d => rectHeight - yScale(d.value))
        .attr('width', 0)
        .attr('height', d => yScale(d.value))
        .style('fill', d => colorScale(d.category))
        .call(enter => 
            enter.transition()
            .duration(750)
            .attr('height', d => yScale(d.value))),
      (update) => update.transition()
        .duration(750)
        .style('fill', d => colorScale(d.category))
        .attrTween('height', function(d, i) {
                const previousHeight = d3.select(this).attr('height') || 0; 
                const interpolator = d3.interpolate(previousHeight, yScale(d.value));
                return t => interpolator(t);
            }),
        exit => exit
            .call(exit => exit.transition()
            .duration(750)
            .attr('height', 0) 
            .remove())
    );


  svg.selectAll('text')
    .data(sortedData)
    .transition()
    .duration(750)
    .text(d => d.category);

  // update chart title
  const displayTitle = props.regionName === 'United States' ? props.regionName : `${props.regionName} Region`;

  svg.selectAll('text.chart-title')
    .data(props.regionName)
    .join(
      enter => enter.append('text')
        .text(displayTitle),
      update => update.transition().duration(750).text(displayTitle)
    );
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