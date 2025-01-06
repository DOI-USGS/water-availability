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
        default: 'lower 48 United States',
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
    .attr('height', height)
    .attr('viewBox', `-20 0 ${width+20} ${height+20}`);
}

// Initialize Legend
function initLegend(data) {

  // Sort data
  const sortedData = processData(data);
  const uniqueCategories = Array.from(new Set(sortedData.map(d => d.category)));
  const dummyData = uniqueCategories.map(category => ({
    category: category, 
    value: 0.2 // assign a fixed value
  }));


  const colorScale = d3.scaleOrdinal()
    .domain(sortedData.map(d => d.category))
    .range(props.layerPaths.colors)

    const xScale = d3.scaleBand()
    .domain(sortedData.map(d => cleanLabel(d.category)))
    .range([0, width - 40])
    .paddingInner(0) 
    .paddingOuter(0);

  const yScale = d3.scaleLinear()
    .domain([0, 1])
    .range([rectHeight, 10]);

  // Bars
  svg.selectAll('rect')
    .data(sortedData, d => cleanLabel(d.category))
    .join('rect')
    .attr('class','main')
    .attr('x', d => xScale(cleanLabel(d.category)))
    .attr('y', d => yScale(d.value))
    .attr('width', xScale.bandwidth())
    .attr('height', d => rectHeight - yScale(d.value))
    .style('fill', d => colorScale(d.category));

    svg.selectAll('rect.static')
    .data(dummyData, d => cleanLabel(d.category))
    .join('rect')
    .attr('class','static')
    .attr('x', d => xScale(cleanLabel(d.category)))
    .attr('y', d => height-25)
    .attr('width', xScale.bandwidth())
    .attr('height', d => rectHeight - yScale(d.value))
    .style('fill', d => colorScale(d.category));

  const axisBottom = d3.axisBottom(xScale)
   .tickFormat(d => d)
   .tickSize(3)
   .tickPadding(2);

   svg.append('g')
    .attr('class', 'x-axis')
    .attr('transform', `translate(0, ${rectHeight})`)
    .call(axisBottom)
    .selectAll('text') // select axis labels
    .style('text-anchor', 'middle') // align to the start (left)
    .attr('x', 0)
    .style('font-size', '14px'); 

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

}

// Update Legend
function updateLegend(data) {
 
  const sortedData = processData(data);
  const uniqueCategories = Array.from(new Set(sortedData.map(d => d.category)));
  const dummyData = uniqueCategories.map(category => ({
    category: category, 
    value: 0.25 // assign a fixed value
  }));

  const xScale = d3.scaleBand()
    .domain(sortedData.map(d => cleanLabel(d.category)))
    .range([0, width - 40])
    .paddingInner(0) 
    .paddingOuter(0);

  const yScale = d3.scaleLinear()
    .domain([0, 1])
    .range([rectHeight, 20]);

  const colorScale = d3.scaleOrdinal()
    .domain(sortedData.map(d => d.category))
    .range(props.layerPaths.colors)

  svg.selectAll('rect.main')
    .data(sortedData, d => cleanLabel(d.category))
    .join(
      enter => enter.append('rect')
      .attr('x', d => xScale(cleanLabel(d.category)))
      .attr('class','main')
        .attr('y', d => yScale(d.value))
        .attr('width', xScale.bandwidth())
        .attr('height', 0)
        .style('fill', d => colorScale(d.category))
        .call(enter => 
            enter.transition()
            .duration(300)
            .attr('y', d => yScale(d.value))
            .attr('height', d => rectHeight - yScale(d.value))
        ),
      update => update.transition()
        .duration(300)
        .attr('y', d => yScale(d.value)) // Adjust position
        .attr('height', d => rectHeight - yScale(d.value)) // Adjust height
        .style('fill', d => colorScale(d.category)),
      exit => exit.transition()
        .duration(300)
        .attr('y', rectHeight) // Collapse downwards
        .attr('height', 0) // Shrink height
        .remove()
    );

    svg.selectAll('rect.static')
    .data(dummyData, d => cleanLabel(d.category))
    .join('rect')
    .attr('class','static')
    .attr('x', d => xScale(cleanLabel(d.category)))
    .attr('y', d => height-25)
    .attr('width', xScale.bandwidth())
    .attr('height', d => rectHeight - yScale(d.value))
    .style('fill', d => colorScale(d.category));

  const axisBottom = d3.axisBottom(xScale)
   .tickFormat(d => d)
   .tickSize(3)
   .tickValues(sortedData.map(d => cleanLabel(d.category)))
   .tickPadding(2);

   d3.select('.x-axis').remove() // clear before updating

   svg.append('g')
    .attr('class', 'x-axis')
    .attr('transform', `translate(0, ${rectHeight})`)
    .call(axisBottom)
    .selectAll('text') // select axis labels
    .style('text-anchor', 'middle') // align to the start (left)
    .attr('x', 0);

  svg.selectAll('.x-axis .tick') // select all ticks
    .attr('transform', function(d) {
      // manually shift tick positions to the left edge of the bars
      return `translate(${xScale(d)}, 0)`;
    });


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