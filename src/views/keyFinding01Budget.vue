<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <p>Water balance is the difference between how much clean water supply there is and how much water are we using. For most of the country, water supply is much higher than water demand, meaning there is more than enough water available to meet our needs. In some regions, however, the difference between water supply and demand is much smaller. Those regions are more likely to experience water stress, meaning there is not enough water available to meet human and ecosystem needs. Between 2010 and 2020, the Southern High Plains, Texas, Central High Plains, and Mississippi Embayment had the most widespread exposure to water stress in the country.</p>
            </div>
            <div class="viz-container">
                <div id="dotplot-container">    
                </div>
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
//console.log(mobileView)

// Global variables 
const publicPath = import.meta.env.BASE_URL;
const dataSet1 = ref([]); 
const data = ref([]);
let svg;
const containerWidth = window.innerWidth * 0.8;
const containerHeight = mobileView ? window.innerHeight * 0.7 : window.innerHeight * 1.5;
const margin = mobileView ? { top: 60, right: 20, bottom: 20, left: 100 } : { top: 10, right: 10, bottom: 10, left: 100 };
const width = containerWidth - margin.left - margin.right;
const height = containerHeight - margin.top - margin.bottom;
let chartBounds;
let dotGroup;

onMounted(async () => {
    try {
        await loadDatasets();
        data.value = dataSet1.value;
        if (data.value.length > 0) {

            //console.log(regionGroups);

            initDotChart({
              containerWidth: containerWidth,
              containerHeight: containerHeight,
              margin: margin,
              width: width,
              height: height
            });
            createDotChart({
              dataset: data.value
            });
        } else {
            console.error('Error loading data');
        }
    } catch (error) {
        console.error('Error during component mounting', error);
    }
});

async function loadDatasets() {
  try {
    dataSet1.value = await loadData('wa_supply_demand.csv');
    console.log('data in');
  } catch (error) {
    console.error('Error loading datasets', error);
  }
};

async function loadData(fileName) {
  try {
    const data = await d3.csv(publicPath + fileName, d => { 
      return d;
    });
    return data;
  } catch (error) {
    console.error(`Error loading data from ${fileName}`, error);
    return [];
  }
};

function initDotChart({
        containerWidth,
        containerHeight,
        margin
    }) {

    // draw svg canvas for sankey
    svg = d3.select('#dotplot-container')
      .append('svg')
      .attr('class', 'sankeySVG')
      .attr('viewBox', `0 0 ${containerWidth} ${containerHeight}`)
      .style('width', '100%')
      .style('height', 'auto');

    // add group for bar chart bounds, translating by chart margins
    chartBounds = svg.append('g')
      .attr('id', 'wrapper')
      .style("transform", `translate(${
        margin.left
      }px, ${
        margin.top
      }px)`)

    // Add group to chart bounds to hold all sankey path groups
    dotGroup = chartBounds.append('g')
      .attr('id', 'dot-group')
    
};

function createDotChart({
    dataset
  }) {

    const yAccessor = d => d["Region_nam"];
    const xAccessorSupply = d => d["supply_mean"];
    const xAccessorDemand = d => d["demand_mean"];


    // scales
    const xScale = d3.scaleLinear()
        .domain(d3.extent(dataset, d => d.supply_mean))
        .range([width, 0])
        .nice()

    const yScale = d3.scaleBand()
        .domain(dataset.map(yAccessor))
        .range([0, height])

    // axes 
    const xAxisGenerator = d3.axisBottom()
        .scale(xScale)

    const xAxis = dotGroup.append("g")
        .call(xAxisGenerator)
            .style("transform", `translateY(${height}px)`)

    const xAxisLabel = xAxis.append("text")
        .attr("x", width / 2)
        .attr("y", margin.bottom  - 10)
        .attr("fill", "black")
        .text("Mean in mm per year")
        .attr('class', 'axis-text')

    const yAxisGenerator = d3.axisLeft()
        .scale(yScale)
        .ticks(18)

    const yAxis = dotGroup.append("g")
        .call(yAxisGenerator)

    const yAxisLabel = yAxis.append("text")
        .attr("x", -height / 2)
        .attr("y", -margin.left + 10)
        .attr("fill", "black")
        .text("Region")
        .style("transform", "rotate(-90deg)")
        .style("text-anchor", "middle")
        .attr('class', 'axis-text')

    // attach data 
    const lineGenerator = d3.line()
    const axisLinePath = d => lineGenerator( [ [xScale(d) + 0.5, 0], [xScale(d) + 0.5, height]])
    const dotsLinePath = d => lineGenerator([ [xScale(xAccessorDemand(d)), xScale(xAccessorSupply(d))], [xScale(xAccessorSupply(d)), 0] ])
  
    const dotsGroup = dotGroup.append("g")
        .attr("class", "dots")
    
    const dots = dotsGroup.selectAll("g")
        .data(dataset)
        .enter().append("g")
            .attr("class", "dot")
            .attr("transform", d => `translate(0, ${(yScale(yAccessor(d)) + (yScale.bandwidth() / 2))})`)
 
    dots.append("path")
        .attr("class", "dots-line")
        .attr("d", dotsLinePath)

    const supplyCircles = dots.append("circle")
        .attr("class", "supply")
        .attr("r", 10)
        .attr("cx", d => xScale(xAccessorSupply(d)))
        .attr("cy", d => yScale(yAccessor(d)))
        .attr("fill", "#669999")

    const demandCircles = dots.append("circle")
        .attr("class", "supply")
        .attr("r", 10)
        .attr("cx", d => xScale(xAccessorDemand(d)))
        .attr("cy", d => yScale(yAccessor(d)))
        .attr("fill", "red")
  
}


</script>

<style scoped>

</style>