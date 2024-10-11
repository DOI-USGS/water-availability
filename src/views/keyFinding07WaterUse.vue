<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <p>Most of our daily water use in the United States is for <span class="highlight" id="Irrigation"> agriculture </span>, followed by fresh water used in the process of creating energy from <span class="highlight" id="Thermoelectric-fresh"> Thermoelectric Power Plants</span>. Along with <span class="highlight" id="Public_Supply"> public supply </span>, these three uses of water add up to 225,000 million gallons of water used per day in the U.S. <span class="highlight" id="Thermoelectric-saline"> Thermoelectric Power Generation (from saline water sources)</span>uses another approximately 21,000 mgd. Combined, public supply, irrigation, and thermoelectric power generation comprise 90% of our daily water use budget. </p>
            </div>
            <div class="viz-container">
                <div id="barplot-container">    
                </div>
            </div>
        </div>
        <PageCarousel></PageCarousel>
    </section>
</template>

<script setup>
import { onMounted, ref, computed } from 'vue';
import PageCarousel from '../components/PageCarousel.vue';
import * as d3 from 'd3';
import KeyMessages from '../components/KeyMessages.vue';
import { isMobile } from 'mobile-device-detect';


// use for mobile logic
const mobileView = isMobile;
//console.log(mobileView)

// Global variables 
const publicPath = import.meta.env.BASE_URL;
const dataSet = ref([]); 
const data = ref([]);
let svg;
const containerWidth = window.innerWidth * 0.8;
const containerHeight = mobileView ? window.innerHeight * 0.7 : 600;
const margin = mobileView ? { top: 60, right: 20, bottom: 20, left: 100 } : { top: 80, right: 20, bottom: 40, left: 100 };
const width = containerWidth - margin.left - margin.right;
const height = containerHeight - margin.top - margin.bottom;
let chartBounds;
let rectGroup;
let useScale;
let useAxis;
let yearScale;
let yearAxis;

// Colors for bar chart (need to be updated along with CSS below!)
const categoryColors = {
        'Public Supply': '#A04747',
        'Irrigation': '#E8B86D',
        'Thermoelectric (fresh)': '#0B2F9F',
        'Thermoelectric (saline)': '#6CBEC7',
      }; 

      onMounted(async () => {
        try {
        await loadDatasets();
        data.value = dataSet.value;
        if (data.value.length > 0) {
            initBarChart({
              containerWidth: containerWidth,
              containerHeight: containerHeight,
              margin: margin,
              width: width,
              height: height
            });
            createBarChart({
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
    dataSet.value = await loadData('wu_yearly.csv');
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

function initBarChart({
  containerWidth,
              containerHeight,
              margin
}) {

    // draw svg canvas for barplot
    svg = d3.select('#barplot-container')
      .append('svg')
      .attr('class', 'barplotSVG')
      .attr('viewBox', `0 0 ${containerWidth} ${containerHeight}`)
      .style('width', containerWidth)
      .style('height', containerHeight);

    // add group for bar chart bounds, translating by chart margins
    chartBounds = svg.append('g')
      .attr('id', 'wrapper')
      .style("transform", `translate(${
        margin.left
      }px, ${
        margin.top
      }px)`)

    // Add group to chart bounds to hold all chart rectangle groups
    rectGroup = chartBounds.append('g')
      .attr('id', 'rectangle_group')

}

function createBarChart({
    dataset
  }) {

    // get unique categories and regions
    const categoryGroups = [... new Set(dataset.map(d => d.Use))];
    const yearGroups = d3.union(d3.map(dataset, d => d.water_year));

    // stack data for rectangles
    const stackedData = d3.stack()
        .keys(categoryGroups)
        .value(([, D], key) => D.get(key)['mgd']) // get value for each series key and stack
        (d3.index(dataset, d => d.water_year, d => d.Use));


    // Set up year scale (x)
    yearScale = d3.scaleBand()
        .domain(yearGroups)
        .range([0, width]); 

    // add year axis
    yearAxis = chartBounds.append('g')
        .attr("transform", "translate(0," + height + ")")
        .call(d3.axisBottom(yearScale))
        .attr('font-size', mobileView ? '1.4rem' : '1.4rem')

    yearAxis
        .select(".domain").remove();

    // Set up water use axis (y)
    useScale = d3.scaleLinear()
        .domain([0, d3.max(stackedData, d => d3.max(d, d => d[1]))])
        .range([height, 0]);

     // create nutrient axis generator
    useAxis = chartBounds.append('g')
      .call(d3.axisLeft(useScale).ticks(4).tickFormat( d => d + ' mgd'))
      .attr('font-size', mobileView ? '1.4rem' : '1.4rem')
    
    // set up color scale
    const colorScale = d3.scaleOrdinal()
        .domain(categoryGroups)
        .range(categoryGroups.map(item => categoryColors[item]));

    // Update groups for bars, assigning data
    var categoryRectGroups = rectGroup.selectAll('g')
        .data(stackedData, d => d.key)
        .attr("id", d => d.key.replace(" ", "_"))
        .join(
          enter => enter
              .append("g")
              .attr("class", d => d.key.replace(" ", ""))
        )

    // Update bars within groups
    categoryRectGroups.selectAll('g')
      .data(D => D.map(d => (d.key = D.key, d)))
      .join(
        enter => enter
            .append("rect")
                .attr("class", d => d.key.replace(" ", "_") + ' ' + d.data[0].replace(" ", "_"))
                .attr("role", "listitem")
                .attr('x', d => yearScale(d.data[0]))
                .attr('y', d => useScale(d[1]))
                .attr('height', d => useScale(d[0]) - useScale(d[1]))
                .attr('width', yearScale.bandwidth() -10)
                .style("fill", d => colorScale(d.key))
      )


    

};

</script>

<style scoped>
.highlight {
  color: white;
  padding: 0.25px 5px;
  border-radius: 10px;
  white-space: nowrap;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.1s;

  &#Public_Supply {
    background-color: #A04747;
  }

  &#Irrigation {
    background-color: #E8B86D;
  }

  &#Thermoelectric-fresh {
    background-color: #0B2F9F;
  }

  &#Thermoelectric-saline {
    background-color: #6CBEC7;
  }
}
</style>