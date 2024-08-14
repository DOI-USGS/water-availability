<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="viz-container">
            <div id="barplot-container" />
            
         </div>
         <div class="viz-container">
            <p>Nutrients have a range of natural and anthropogenic sources. Natural sources of nutrients in surface water include fixation of atmospheric nitrogen by soil bacteria that is transported to streams, geogenic sources, fixation by aquatic bacteria and algae, and lightning strikes. Anthropogenic sources of nutrients in surface water generally include nonpoint fertilizer and manure application, atmospheric deposition (which generally has anthropogenic origins), nitrogen fixation by crops, and point sources such as wastewater treatment plant discharge. Legacy nitrogen stored in groundwater can also be important sources to streams as well. Across the CONUS, primary sources vary spatially, and include fertilizer and manure, atmospheric deposition, wastewater treatment plants, urban land, and a range of natural sources including stream channel and geologic sources.</p>
        
         </div>
         
         <PageCarousel></PageCarousel>
    </section>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import * as d3 from 'd3';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';

// Global variables 
const publicPath = import.meta.env.BASE_URL;
const dataSet1 = ref([]); 
const dataSet2 = ref([]); 
const selectedDataSet = ref('dataSet1');
const data = ref([]);
let svg;
const height = 600;
const width = 800;
const margin = { top: 40, right: 20, bottom: 40, left: 40 };


// Set colors for bubble charts
const dimensionColors = {
  AtmosphericDeposition: "#092836",
  Imports: "#1b695e",
  Wastewater: "#7a5195",
  Developed: "#2a468f",
  NitrogenFixation: "#ef5675",
  FertilizerAndManure: "#ff764a",
  Springs: "#ffa600"
};



onMounted(async () => {
    try {
        await loadDatasets();
        data.value = selectedDataSet.value === 'dataSet1' ? dataSet1.value : dataSet2.value;
        if (data.value.length > 0) {
        createBarChart();
        } else {
        console.error('Error loading data');
        }
    } catch (error) {
        console.error('Error during component mounting', error);
    }
});

async function loadDatasets() {
  try {
    dataSet1.value = await loadData('nitrogen_by_source.csv');
    dataSet2.value = await loadData('phosphorus_by_source.csv');
    console.log('data in');
  } catch (error) {
    console.error('Error loading datasets', error);
  }
};

async function loadData(fileName) {
  try {
    const data = await d3.csv(publicPath + fileName, d => { 
      d.level_agreement = +(+d.level_agreement).toFixed(2); 
      d.evidence_val = +d.evidence_val; 
      d.sig_value = +d.sig_value; 
      return d;
    });
    return data;
  } catch (error) {
    console.error(`Error loading data from ${fileName}`, error);
    return [];
  }
};

function createBarChart() {
    // Get dynamic dimensions to draw chart
    const containerWidth = document.getElementById('barplot-container').offsetWidth;
    const containerHeight = window.innerWidth <= 700 ? window.innerHeight * 0.5 : 600;
    const margin = window.innerWidth <= 700 ? { top: 40, right: 10, bottom: 20, left: 10 } : { top: 40, right: 20, bottom: 40, left: 40 };
    const width = containerWidth - margin.left - margin.right;
    const height = containerHeight - margin.top - margin.bottom;

    svg = d3
        .select('#barplot-container')
        .append('svg')
        .attr('class', 'barplotSVG')
        .attr('viewBox', `0 0 ${containerWidth} ${containerHeight}`)
        .attr('preserveAspectRatio', 'xMidYMid meet')
        .style('width', '80%')
        .style('height', 'auto');

    const yScale = d3.scaleLinear()
        .domain([0, d3.max(data.value, d => d.total_load)])
        .range([containerHeight - margin.bottom, margin.top]);

    const yAxis = svg.append('g')
        .call(d3.axisLeft(yScale)
            .ticks(5)
            .tickFormat(d => d + 'kg/yr'))
        .attr('stroke-width', 2)
        .attr('font-size', 18);

    const xScale = d3.scaleOrdinal()
        .domain(["Atlantic Coast", "California-Nevada", "Central High Plains", "Central Rockies", "Columbia-Snake", "Florida", "Great Lakes", "Gulf Coast", "Midwest", "Mississippi Embayment", "Northeast", "Northern High Plains", "Pacific Northwest", "Souris-Red-Rainy", "Southern High Plains", "Southwest Desert", "Tennessee-Missouri", "Texas"])
        .range([containerWidth - margin.left, 0]);

    const xAxis = svg.append('g')
        .call(d3.axisBottom(xScale))

}

</script>

<style scoped>

</style>