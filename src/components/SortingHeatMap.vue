<template>
<div class="chart-container">
    <svg ref="chartSVG" class="chart-svg"></svg>
</div>
</template>

<script setup>
import { onMounted, ref, defineProps, watch } from 'vue';
import * as d3 from 'd3';

// define props
const props = defineProps({
    categoricalVariable: { type: String, required: true },
    colorVariable: { type: String, required: true },
    continuousRaw: { type: String, required: true },
    layerPaths: { 
        type: Object, 
        required: true // expects breaks and colors
    },
    dataDW: { 
        type: Array, 
        required: true // expects drinking water data
    },
    dataRec: { 
        type: Array, 
        required: true // expects recreational data
    },
    dataFish: { 
        type: Array, 
        required: true // expects fish consumption data
    },
    useName: { 
        type: String, 
        default: 'Drinking Water',
        require: true // default use for sorting on load
    },
});

const chartSVG = ref(null);
let svg;

// chart dimensions
const width = 700;
const height = 700;
const rectHeight = 30; //approx: height - margin / 18 classes with room for wiggle
const marginTop = 20;


// render legend initially and watch for changes
onMounted(() => {

    setupSVG();
    initChart(props.dataDW);
});

 // Watch for updates in data or region name
watch(
  () => [props.dataDW, props.useName],
  ([newData, newRegion]) => {
    updateChart(newData, newRegion);
  },
  { deep: true }
);

// create svg only once
function setupSVG() {
  svg = d3.select(chartSVG.value)
    .attr('width', width)
    .attr('height', height)
    .attr('viewBox', `-20 0 ${width+20} ${height}`);

}

// Initialize Legend
function initChart(dataDW) {

    console.log("test before")
  const xScale = d3.scaleLinear()
    .domain([0, d3.sum(dataDW.continuousRaw)])
    .range([0, width - 40]);

    console.log("test after")
  const yScale = d3.scaleBand()
    .domain(dataDW.categoricalVariable)
    .range([rectHeight, 10])
    .paddingInner(0) 
    .paddingOuter(0);


  // Bars
  svg.selectAll('rect')
    .data(sortedData, d => d.categoricalVar)
    .join('rect')
    .attr('y', d => yScale(d.categoricalVariable))
    .attr('x', d => xScale(d.continuousRaw))
    .attr('width', d => rectHeight - xScale(d.continuousRaw))
    .attr('height', yScale.bandwidth())

}

// Update Legend
function updateChart(data) {
  
  
}



</script>

<style scoped>

.legend-svg {
  width: 100%;
  height: auto;
  max-height: 100%;
}
</style>