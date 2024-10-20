<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <p>Water balance is the difference between how much clean water supply there is and how much water are we using. For most of the country, <span class="highlight" id="supply">water supply</span> is much higher than <span class="highlight" id="demand">water demand</span>, meaning there is more than enough water available to meet our needs. 
                  </p>
            </div>
        <div class="viz-container">
          <div id="dotplot-container"> </div>   
        </div>
        <div class="text-container">
        <p>
          Water stress occurs when there is not enough water available to meet human and ecosystem needs. This is more likely to happen in  regions where the difference between water supply and demand is fairly small. Between 2010 and 2020, the Southern High Plains, Texas, Central High Plains, and Mississippi Embayment had the most widespread exposure to water stress in the country.
        </p>
      </div>
      </div>
        <PageCarousel></PageCarousel>
    </section>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import * as d3 from 'd3';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import { isMobile } from 'mobile-device-detect';

// use for mobile logic
const mobileView = isMobile;

// Global variables 
const publicPath = import.meta.env.BASE_URL;
const dataSet1 = ref([]); 
const data = ref([]);
let svg;
const containerWidth = window.innerWidth * 0.6;
const containerHeight = mobileView ? window.innerHeight * 0.8 : window.innerHeight * 0.50;
let margin = { top: 60, right: 200, bottom: 50, left: 300 };
let width = containerWidth - margin.left - margin.right;
let height = containerHeight - margin.top - margin.bottom;
let chartBounds, dotGroup;

onMounted(async () => {
    try {
        await loadDatasets();
        data.value = dataSet1.value;
        if (data.value.length > 0) {
            initDotChart();
            createDotChart();
        } else {
            console.error('Error loading data');
        }
    } catch (error) {
        console.error('Error during component mounting', error);
    }
});

async function loadDatasets() {
    dataSet1.value = await loadData('wa_supply_demand.csv');
};

async function loadData(fileName) {
    try {
        const data = await d3.csv(publicPath + fileName, d => d);
        return data;
    } catch (error) {
        console.error(`Error loading data from ${fileName}`, error);
        return [];
    }
};

function initDotChart() {
    svg = d3.select('#dotplot-container')
      .append('svg')
      .attr('viewBox', `0 0 ${containerWidth} ${containerHeight}`)
      .style('width', '100%')
      .style('height', 'auto');

    chartBounds = svg.append('g')
      .attr('transform', `translate(${margin.left}, ${margin.top})`);

    dotGroup = chartBounds.append('g');
}

function createDotChart() {
    const dataset = data.value;

    if (!dataset || dataset.length === 0) {
        console.error("No dataset available for creating the dot chart");
        return;
    }

    const yAccessor = d => d["Region_nam"];
    const xAccessorSupply = d => d["supply_mean"];
    const xAccessorDemand = d => d["demand_mean"];

    // scales
    const xScale = d3.scaleLinear()
        .domain(d3.extent(dataset, d => +d.supply_mean))
        .range([0, width])
        .nice();

    const yScale = d3.scaleBand()
        .domain(dataset.map(yAccessor))
        .range([0, height])
        .padding(0.1);

    // Remove old elements (if any) to avoid overlaps
    dotGroup.selectAll("*").remove();

    // Append axes
    dotGroup.append('g')
        .attr('class', 'x-axis')
        .attr('transform', `translate(0, ${height})`)
        .call(d3.axisBottom(xScale).ticks(5));

    dotGroup.append('g')
        .attr('class', 'y-axis')
        .call(d3.axisLeft(yScale));

    // Add dots and lines
    dotGroup.selectAll(".line")
        .data(dataset)
        .enter().append('line')
        .attr('x1', d => xScale(d.supply_mean))
        .attr('x2', d => xScale(d.demand_mean))
        .attr('y1', d => yScale(d.Region_nam) + yScale.bandwidth() / 2)
        .attr('y2', d => yScale(d.Region_nam) + yScale.bandwidth() / 2)
        .attr('stroke', '#ccc');

    dotGroup.selectAll(".circle-supply")
        .data(dataset)
        .enter().append('circle')
        .attr('cx', d => xScale(d.supply_mean))
        .attr('cy', d => yScale(d.Region_nam) + yScale.bandwidth() / 2)
        .attr('r', 5)
        .attr('fill', '#669999');

    dotGroup.selectAll(".circle-demand")
        .data(dataset)
        .enter().append('circle')
        .attr('cx', d => xScale(d.demand_mean))
        .attr('cy', d => yScale(d.Region_nam) + yScale.bandwidth() / 2)
        .attr('r', 5)
        .attr('fill', '#F87A53');
}



</script>

<style scoped>
.content-container {
  display: block;
}
#viz-container {
  width: 90%;
  max-width: 1000px;
  margin: 20px auto;
  display: block;
}
#dotplot-container{
  width: 100%;
}
.text-container {
  margin: 20px auto;
}
.highlight {
  color: white;
  padding: 0.25px 5px;
  border-radius: 10px;
  white-space: nowrap;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.1s;

  &#supply {
    background-color: #669999;
  }

  &#demand {
    background-color: #F87A53;
  }

}
</style>