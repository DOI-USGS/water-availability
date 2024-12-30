<template>
    <div class="chart-container">
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
  const height = 120;
  const rectHeight = 80;
  const marginTop = 20;


  // render legend initially and watch for changes
  onMounted(() => {
    setupSVG();
    initLegend(props.data);
    });
    
 // Watch for updates in data or region name
watch(
  () => [props.data, props.regionName],
  ([newData, newRegion]) => {
    updateLegend(newData, newRegion);
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
    .range([0, width - 40])
    .paddingInner(0) 
    .paddingOuter(0);

  const yScale = d3.scaleLinear()
    .domain([0, 1])
    .range([rectHeight, 10]);

  // Bars
  svg.selectAll('rect')
    .data(sortedData, d => d.category)
    .join('rect')
    .attr('x', d => xScale(d.category))
    .attr('y', d => yScale(d.value))
    .attr('width', xScale.bandwidth())
    .attr('height', d => rectHeight - yScale(d.value))
    .style('fill', d => colorScale(d.category));

  const axisBottom = d3.axisBottom(xScale)
   .tickFormat(d => d)
   .tickSize(3)
   .tickPadding(0);

   svg.append('g')
    .attr('class', 'x-axis')
    .attr('transform', `translate(0, ${rectHeight})`)
    .call(axisBottom)
    .selectAll('text') // select axis labels
    .style('text-anchor', 'start') // align to the start (left)
    .attr('x', 0); 

  svg.selectAll('.x-axis .tick') // select all ticks
  .attr('transform', function(d) {
    // manually shift tick positions to the left edge of the bars
    return `translate(${xScale(d)}, 0)`;
  });


// add y-axis
 const axisRight = d3.axisRight(yScale).ticks(3).tickFormat(d => `${d * 100}%`).tickSize(3);

  svg.append('g')
    .attr('class', 'y-axis')
    .attr('transform', `translate(${width-40}, 0)`)
    .call(axisRight) 

  const displayTitle = props.regionName === 'United States' ? props.regionName : `${props.regionName} Region`;

  svg.selectAll('.chart-title')
    .data([displayTitle])
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
  const sortedData = data;

  const xScale = d3.scaleBand()
    .domain(sortedData.map(d => d.category))
    .range([0, width - 40])
    .paddingInner(0) 
    .paddingOuter(0);

  const yScale = d3.scaleLinear()
    .domain([0, 1])
    .range([rectHeight, 20]);

  const colorScale = d3.scaleOrdinal()
    .domain(sortedData.map(d => d.category))
    .range(colors)

  svg.selectAll('rect')
    .data(sortedData, d => d.category)
    .join(
      enter => enter.append('rect')
      .attr('x', d => xScale(d.category))
        .attr('y', d => yScale(d.value))
        .attr('width', xScale.bandwidth())
        .attr('height', 0)
        .style('fill', d => colorScale(d.category))
        .call(enter => 
            enter.transition()
            .duration(550)
            .attr('y', d => yScale(d.value))
            .attr('height', d => rectHeight - yScale(d.value))
        ),
      update => update.transition()
        .duration(550)
        .attr('y', d => yScale(d.value)) // Adjust position
        .attr('height', d => rectHeight - yScale(d.value)) // Adjust height
        .style('fill', d => colorScale(d.category)),
      exit => exit.transition()
        .duration(550)
        .attr('y', rectHeight) // Collapse downwards
        .attr('height', 0) // Shrink height
        .remove()
    );

  const axisBottom = d3.axisBottom(xScale)
   .tickFormat(d => d)
   .tickSize(3)
   .tickValues(sortedData.map(d => d.category))
   .tickPadding(0)
   .tickSizeOuter(0);

   d3.select('.x-axis').remove() // clear before updating

   svg.append('g')
    .attr('class', 'x-axis')
    .attr('transform', `translate(0, ${rectHeight})`)
    .call(axisBottom)
    .selectAll('text') // select axis labels
    .style('text-anchor', 'start') // align to the start (left)
    .attr('x', 0);

  svg.selectAll('.x-axis .tick') // select all ticks
    .attr('transform', function(d) {
      // manually shift tick positions to the left edge of the bars
      return `translate(${xScale(d)}, 0)`;
    });


  // update chart title
  const displayTitle = props.regionName === 'United States' ? props.regionName : `${props.regionName} Region`;

  svg.selectAll('text.chart-title')
    .data([displayTitle])
    .join(
      enter => enter.append('text')
        .attr('class', 'chart-title')
        .attr('x', 10)
        .attr('y', 30)
        .attr('fill', 'black')
        .attr('font-size', '2.25rem')
        .attr('font-weight', 'bold')
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
// Clean labels by extracting first number in string
function cleanLabel(label) {
  const match = label.match(/\d+/); // Extract first number
  return match ? match[0] : label;  // Return number or original label
}

</script>

<style scoped>

.legend-svg {
  width: 100%;
  height: auto;
  max-height: 100%;
}
</style>