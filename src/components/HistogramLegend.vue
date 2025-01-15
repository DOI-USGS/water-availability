<template>
    <div class="chart-container" id="bar-container">
      <svg ref="legendSvg" class="legend-svg" ></svg>
    </div>
  </template>
  
  <script setup>
  import { onMounted, ref, watch } from 'vue';
  import * as d3 from 'd3';
  import { isMobile } from 'mobile-device-detect';
  
  const mobileView = isMobile;
  let histogramWidth;
  let histogramHeight;
  let rectHeight;
  let marginLeft;
  let marginRight;

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
  


  // render legend initially and watch for changes
  onMounted(() => {

      // chart dimensions
    const containerWidth = document.getElementById('bar-container').clientWidth;
    histogramWidth = mobileView ? containerWidth : 700;
    histogramHeight = 120;
    rectHeight = 80;
    marginLeft = mobileView ? -4 : -30;
    marginRight = mobileView ? 40 : 80;

    setupSVG();
    
    initLegend(props.data, props.layerPaths.name);
    });
    
 // Watch for updates in data or region name
watch(
  () => props.data,
  () => {
    updateLegend(props.data, props.layerPaths.name);
  },
  { deep: true }
);
watch(
  () => props.layerPaths, // watch layerPaths for changes
  () => {
    setupSVG(); // clear and reinitialize the SVG
    initLegend(props.data, props.layerPaths.name); // rerun initLegend with updated data
  },
  { deep: true } // deep watch in case layerPaths contains nested objects
);

// create svg only once
function setupSVG() {
  d3.select(legendSvg.value).selectAll('*').remove();
  svg = d3.select(legendSvg.value)
    .attr('width', histogramWidth)
    .attr('height', histogramHeight)
    .attr('viewBox', `${marginLeft} 0 ${histogramWidth + marginRight} ${histogramHeight}`)
    .attr('preserveAspectRatio', 'xMidYMid meet')
    .attr('aria-role', 'image')
    .attr('aria-label', 'Combination legend and histogram showing the distribution of the varying levels of nitrogen or phosphorus loads from lower loads to high loads. Across the U.S., most watersheds have relatively high loads of nitrogen (greater than 12,000 kilograms per year) or phosphorus (greater than 1,000 kilograms per year).');
}

// Initialize Legend
function initLegend(data, variable) {
  // Sort data
  const sortedData = processData(data, variable);
  
  // for adding legend below histogram
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
    .range([0, histogramWidth])
    .paddingInner(0) 
    .paddingOuter(0);

  const yScale = d3.scaleLinear()
    .domain([0, 1])
    .range([rectHeight, 10]);

  // Bars
  svg.selectAll('rect')
    .data(sortedData, d => d.uniqueIdentifier)
      .join('rect')
      .attr('class', d => 'main' + ' ' + d.uniqueIdentifier)
      .attr('x', d => xScale(cleanLabel(d.category)))
      .attr('y', d => yScale(d.value))
      .attr('width', xScale.bandwidth())
      .attr('height', d => rectHeight - yScale(d.value))
      .style('fill', d => colorScale(d.category))
      .attr('aria-hidden', 'true');

    svg.selectAll('rect.static')
      .data(dummyData, d => cleanLabel(d.category))
        .join('rect')
        .attr('class','static')
        .attr('x', d => xScale(cleanLabel(d.category)))
        .attr('y', mobileView ? histogramHeight - 20 : histogramHeight - 15)
        .attr('width', xScale.bandwidth())
        .attr('height', d => rectHeight - yScale(d.value))
        .style('fill', d => colorScale(d.category))
        .attr('aria-hidden', 'true');


  const axisBottom = d3.axisBottom(xScale)
   .tickFormat(d => d)
   .tickSize(3)
   .tickPadding(2);

   svg.append('g')
    .attr('id', 'x-axis')
    .attr('class', 'axis-text')
    .attr('transform', `translate(0, ${rectHeight})`)
    .attr('aria-hidden', 'true')
    .call(axisBottom)
      .selectAll('text') // select axis labels
      .style('text-anchor', 'middle') // align to the middle
      .attr('x', 0)
      .attr('aria-hidden', 'true'); 

  svg.selectAll('#x-axis .tick') // select all ticks
  .attr('transform', function(d) {
    // manually shift tick positions to the left edge of the bars
    return `translate(${xScale(d)}, 0)`;
  });


// add y-axis
 const axisRight = d3.axisRight(yScale)
  .ticks(3)
  .tickFormat(d => `${d * 100}%`)
  .tickSize(3);

  svg.append('g')
    .attr('id', 'y-axis')
    .attr('class', 'axis-text')
    .attr('transform', `translate(${histogramWidth}, 0)`)
    .call(axisRight) 
    .attr('aria-hidden', 'true')

}

// Update Legend
function updateLegend(data, variable) {
  const sortedData = processData(data, variable);
  const uniqueCategories = Array.from(new Set(sortedData.map(d => d.category)));
  const dummyData = uniqueCategories.map(category => ({
    category: category, 
    value: 0.25 // assign a fixed value
  }));

  const xScale = d3.scaleBand()
    .domain(sortedData.map(d => cleanLabel(d.category)))
    .range([0, histogramWidth])
    .paddingInner(0) 
    .paddingOuter(0);


  const yScale = d3.scaleLinear()
    .domain([0, 1])
    .range([rectHeight, 20]);

  
  const colorScale = d3.scaleOrdinal()
    .domain(sortedData.map(d => d.category))
    .range(props.layerPaths.colors)

  svg.selectAll('rect.main')
    .data(sortedData, d => d.uniqueIdentifier)
    .join(
      enter => enter.append('rect')
        .attr('x', d => xScale(cleanLabel(d.category)))
        .attr('class', d => 'main' + ' ' + d.uniqueIdentifier)
        .attr('y', d => yScale(d.value))
        .attr('width', xScale.bandwidth())
        .attr('height', 0)
        .style('fill', d => colorScale(d.category))
        .attr('aria-hidden', 'true')
        .call(enter => 
            enter.transition()
            .duration(300)
            .attr('y', d => yScale(d.value))
            .attr('height', d => rectHeight - yScale(d.value))
            .attr('aria-hidden', 'true')
        ),
      update => update.transition()
        .attr('x', d => xScale(cleanLabel(d.category))) // adjust x position immediately
        .attr('class', d => 'main' + ' ' + d.uniqueIdentifier)
        .duration(300)
        .attr('y', d => yScale(d.value)) // Adjust position
        .attr('height', d => rectHeight - yScale(d.value)) // Adjust height
        .style('fill', d => colorScale(d.category))
        .attr('aria-hidden', 'true'),
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
    .attr('y', mobileView ? histogramHeight - 20 : histogramHeight - 15)
    .attr('width', xScale.bandwidth())
    .attr('height', d => rectHeight - yScale(d.value))
    .style('fill', d => colorScale(d.category))
    .attr('aria-hidden', 'true');


  const axisBottom = d3.axisBottom(xScale)
   .tickFormat(d => d)
   .tickSize(3)
   .tickValues(sortedData.map(d => cleanLabel(d.category)))
   .tickPadding(2);

   d3.select('#x-axis').remove() // clear before updating

   svg.append('g')
    .attr('id', 'x-axis')
    .attr('class', 'axis-text')
    .attr('transform', `translate(0, ${rectHeight})`)
    .attr('aria-hidden', 'true')
    .call(axisBottom)
    .selectAll('text') // select axis labels
    .style('text-anchor', 'middle') // align to the middle
    .attr('x', 0)
    .attr('aria-hidden', 'true');

  svg.selectAll('#x-axis .tick') // select all ticks
    .attr('transform', function(d) {
      // manually shift tick positions to the left edge of the bars
      return `translate(${xScale(d)}, 0)`;
    });


}

// Process Data
function processData(data, variable) {
  return data
    .map(d => {
      // Validate and handle missing or invalid 'category' field
      const category = d.category && typeof d.category === 'string' ? d.category : '0';
      const identifier = category + variable;
      return {
        ...d,
        uniqueIdentifier: identifier,
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
  @media only screen and (max-width: 600px) {
    .chart-container {
      width: 90vw;
      margin: 0 auto;
    }
  }
</style>