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
  onMounted(initLegend);
    
  // render legend
  function initLegend() {
    // clear existing legend
    d3.select(legendSvg.value).selectAll('*').remove();
  
    const { breaks, colors } = props.layerPaths;

    // sort the binned groups based on the first number in the labels
    const sortedData = props.data
    .map(d => ({
      ...d,
      numericValue: parseFloat(d.category.match(/\d+/)) || 0 // extract first number
    }))
    .sort((a, b) => a.numericValue - b.numericValue);

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
function updateLegend(data, region) {

// ensure svg exists before proceeding
  if (!svg) {
    return; 
  }
    // process and sort data
    const sortedData = props.data
    .map(d => ({
      ...d,
      numericValue: parseFloat(d.category.match(/\d+/)) || 0 // extract first number
    }))
    .sort((a, b) => a.numericValue - b.numericValue);

  const { colors } = props.layerPaths;
  const rectHeight = 70;

  // x scale for categories
  const xScale = d3.scaleBand()
    .domain(sortedData.map(d => d.category))
    .range([0, 700 - 20])
    .padding(0.1);

  // y scale for heights
  const yScale = d3.scaleLinear()
    .domain([0, d3.max(sortedData, d => +d.value)]) // dynamically scale to new data
    .range([0, rectHeight]);

  // select and update histogram bars
  svg.selectAll('rect')
    .data(sortedData)
    .transition() // smooth transition
    .duration(750) // animation duration
    .attr('y', d => rectHeight - yScale(d.value)) // transition heights
    .attr('height', d => yScale(d.value)) // transition heights
    .style('fill', (d, i) => colors[i % colors.length]); // update colors

  // update labels
  svg.selectAll('text')
    .data(sortedData)
    .transition() // smooth transition for labels
    .duration(750)
    .text(d => d.category);
}

// WATCHERS
// watch all relevant props for updates
watch(
    () => [props.layerPaths, props.data],
    initLegend,
    { deep: true }
  );
  watch(
  () => [props.data, props.regionName],
  ([data, regionName]) => {
    // check if svg is initialized, if not, init
    if (!svg) {
      initLegend();
    }
    // if it exists
    // filter data for the given region
    const filteredData =
      regionName === 'United States'
        ? data // show all data for US
        : data.filter(d => d.Region_nam === regionName); // filter for selected region

    updateLegend(filteredData, regionName); // transition 
  },
  { deep: true }
);

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
  