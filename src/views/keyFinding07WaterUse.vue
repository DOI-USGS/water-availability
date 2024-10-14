<template>
  <section class="main-container">
    <KeyMessages></KeyMessages>
    <div class="content-container">
      <div class="text-container">
        <p>
          Most of our daily water use in the United States is for
          <span class="highlight" id="Irrigation"> agriculture </span>,
          followed by fresh water used in the process of creating energy from
          <span class="highlight" id="Thermoelectric-fresh"> Thermoelectric Power Plants</span>. Along with
          <span class="highlight" id="Public_Supply"> public supply </span>,
          these three uses of water add up to 225,000 million gallons of water used per day in the U.S.
          <span class="highlight" id="Thermoelectric-saline"> Thermoelectric Power Generation (from saline water sources)</span>
          uses another approximately 21,000 mgd. Combined, public supply, irrigation, and thermoelectric power generation comprise 90% of our daily water use budget.
        </p>
      </div>
      <div class="viz-container">
        <div id="barplot-container"></div>
      </div>
    </div>
    <button @click="toggleFacetedView">Toggle View</button>
    <PageCarousel></PageCarousel>
  </section>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import * as d3 from 'd3';
import KeyMessages from '../components/KeyMessages.vue';
import PageCarousel from '../components/PageCarousel.vue';
import { isMobile } from 'mobile-device-detect';

const isFaceted = ref(false); // Track the current view state (stacked or faceted)
const mobileView = isMobile; // Detect mobile view for responsive design

// Global variables to hold chart elements and data
let svg, chartBounds, rectGroup, useAxis, yearAxis;
let categoryGroups, yearGroups, stackedData;
let yearScale, useScale, categoryRectGroups;
const containerWidth = window.innerWidth * 0.8;
const containerHeight = mobileView ? window.innerHeight * 0.7 : 600;
const margin = mobileView ? { top: 60, right: 20, bottom: 20, left: 100 } : { top: 80, right: 20, bottom: 40, left: 100 };
const width = containerWidth - margin.left - margin.right;
const height = containerHeight - margin.top - margin.bottom;

// Define colors for each category group
const categoryColors = {
  'Public Supply': '#A04747',
  'Irrigation': '#E8B86D',
  'Thermoelectric (fresh)': '#0B2F9F',
  'Thermoelectric (saline)': '#6CBEC7',
};

// Helper function to create valid CSS selectors by replacing special characters
function sanitizeSelector(str) {
  return str.replace(/[ ()]/g, '_');
}

// Data references
const dataSet = ref([]);
const data = ref([]);

// Function to load the datasets
async function loadDatasets() {
  try {
    const result = await d3.csv('wu_yearly.csv', d => d);
    dataSet.value = result;
  } catch (error) {
    console.error('Error loading data:', error);
  }
}

// Initialize the SVG canvas and groups
function initBarChart() {
  svg = d3.select('#barplot-container')
    .append('svg')
    .attr('class', 'barplotSVG')
    .attr('viewBox', `0 0 ${containerWidth} ${containerHeight}`)
    .style('width', containerWidth)
    .style('height', containerHeight);

  chartBounds = svg.append('g')
    .attr('id', 'wrapper')
    .attr('transform', `translate(${margin.left}, ${margin.top})`);

  rectGroup = chartBounds.append('g').attr('id', 'rectangle_group');
}

// Function to create the initial bar chart in stacked form
function createBarChart({ dataset }) {
  // Extract unique categories and years
  categoryGroups = [...new Set(dataset.map(d => d.Use))];
  yearGroups = d3.union(dataset.map(d => d.water_year));

  // Stack the data for the stacked bar chart
  stackedData = d3.stack()
    .keys(categoryGroups)
    .value(([, D], key) => D.get(key)['mgd'])
    (d3.index(dataset, d => d.water_year, d => d.Use));

  // X-axis (year scale)
  yearScale = d3.scaleBand()
    .domain(yearGroups)
    .range([0, width])
    .padding(0.1);

  yearAxis = chartBounds.append('g')
    .attr('transform', `translate(0, ${height})`)
    .call(d3.axisBottom(yearScale))
    .attr('font-size', mobileView ? '1.4rem' : '1.4rem');

  yearAxis.select(".domain").remove();

  // Y-axis (water use scale)
  useScale = d3.scaleLinear()
    .domain([0, d3.max(stackedData, d => d3.max(d, d => d[1]))])
    .range([height, 0]);

  useAxis = chartBounds.append('g')
    .call(d3.axisLeft(useScale).ticks(4).tickFormat(d => d + ' mgd'))
    .attr('font-size', mobileView ? '1.4rem' : '1.4rem');

  // Create color scale for the bars
  const colorScale = d3.scaleOrdinal()
    .domain(categoryGroups)
    .range(categoryGroups.map(item => categoryColors[item]));

  // Create grouped bars for each category
  categoryRectGroups = rectGroup.selectAll('g')
    .data(stackedData, d => d.key)
    .join(enter => enter.append('g').attr('id', d => sanitizeSelector(d.key)));

  categoryRectGroups.selectAll('rect')
    .data(D => D.map(d => (d.key = D.key, d)))
    .join(enter => enter.append('rect')
      .attr('x', d => yearScale(d.data[0]))
      .attr('y', d => useScale(d[1]))
      .attr('height', d => useScale(d[0]) - useScale(d[1]))
      .attr('width', yearScale.bandwidth() - 10)
      .style('fill', d => colorScale(d.key)));
}

// Toggle between stacked and faceted views
function toggleFacetedView() {
  isFaceted.value = !isFaceted.value;
  updateChart();
}

// Update the chart view based on the current state
function updateChart() {
  if (isFaceted.value) {
    transitionToFaceted();
  } else {
    transitionToStacked();
  }
}

// Transition the chart to a faceted view (split vertically)
function transitionToFaceted() {
  const facetHeight = height / categoryGroups.length;

  // Move each category to its own facet along the y-axis
  categoryGroups.forEach((group, i) => {
    const groupScale = d3.scaleLinear()
      .domain([0, d3.max(stackedData[i], d => d[1])])
      .range([facetHeight, 0]);

      console.log(`#${sanitizeSelector(group)} x is at ${(4-i) * facetHeight}`)

    d3.selectAll('rect')
      .transition()
      .duration(1000)
      .attr('y', d => groupScale(d[1]) - groupScale(d[0]))
      .attr('height', d => groupScale(d[0]) - groupScale(d[1]));

    d3.select(`g #${sanitizeSelector(group)}`)
      .transition()
      .duration(1000)
      .attr('transform', `translate(0, ${i * facetHeight})`)
      //.attr('y', d => groupScale(d[1]))
      

    // Add a y-axis for each facet
    chartBounds.append('g')
      .attr('class', 'y-axis')
      .attr('transform', `translate(0, ${i * facetHeight})`)
      .call(d3.axisLeft(groupScale).ticks(4).tickFormat(d => d + ' mgd'));
  });

  useAxis.transition().duration(500).style('opacity', 0).remove(); // Remove shared y-axis
}

// Transition the chart back to a stacked view
function transitionToStacked() {
  useScale = d3.scaleLinear()
    .domain([0, d3.max(stackedData, d => d3.max(d, d => d[1]))])
    .range([height, 0]);

  yearScale.range([0, width]);

  // Transition the bars back to the stacked position
  categoryRectGroups.transition()
    .duration(1000)
    .attr('transform', 'translate(0, 0)')
    .selectAll('rect')
    .transition()
    .duration(1000)
    .attr('x', d => yearScale(d.data[0]))
    .attr('y', d => useScale(d[1]))
    .attr('height', d => useScale(d[0]) - useScale(d[1]));

  useAxis = chartBounds.append('g')
    .call(d3.axisLeft(useScale).ticks(4).tickFormat(d => d + ' mgd'))
    .attr('font-size', mobileView ? '1.4rem' : '1.4rem');
}

// On mounted loads data and initializes the chart
onMounted(async () => {
  await loadDatasets();
  if (dataSet.value.length > 0) {
    data.value = dataSet.value;
    initBarChart();
    createBarChart({ dataset: data.value });
  }
});
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
