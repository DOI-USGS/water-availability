<template>
  <section class="main-container">
    <KeyMessages></KeyMessages>
    <div class="content-container">
      <div class="text-container">
        <p>
          Around 90% of daily water use in the United States comes from public supply, agriculture, and thermoelectric power generation. Most of our daily water use is for
          <span class="highlight" id="Irrigation">agriculture </span>
          followed by fresh water used in the process of creating energy from
          <span class="highlight" id="Thermoelectric_fresh"> Thermoelectric power</span> plants. Along with
          <span class="highlight" id="Public_Supply"> public supply </span>,
          these three uses of water add up to 225,000 million gallons of water used per day in the U.S.
          <span class="highlight" id="Thermoelectric_saline"> Thermoelectric power (from saline water)</span>
          uses another approximately 21,000 mgd.
        </p>
      </div>
      
      <!-- Dropdown for selecting view mode -->
      <div class="dropdown-container">
        <select v-model="selectedView" @change="handleViewChange">
          <option value="stacked">Show total annual use</option>
          <option value="faceted">Show by use type</option>
        </select>
      </div>
      
      <div class="viz-container">
        <div id="barplot-container"></div>
      </div>
      
      <div class="text-container">
        <p>
          Water use reflects human dependence on freshwater resources for public health and economic development. Water use has dual effects on water availability. On the one hand, ensuring safe, reliable sources of water for human needs is a primary objective of water management. On the other hand, water withdrawals decrease availability for downstream users and local stream ecosystems. Therefore, areas with more intense water use have higher needs and a higher tendency to degrade the resource than areas with less intense water use.
        </p>
      </div>
      
      <Methods></Methods>
      <References></References>
    </div>
    <!-- conditionally render PageCarousel for preview site -->
    <PageCarousel v-if="showCarousel"></PageCarousel>
  </section>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import * as d3 from 'd3';
import KeyMessages from '../components/KeyMessages.vue';
import PageCarousel from '../components/PageCarousel.vue';
import Methods from '../components/Methods.vue';
import References from '../components/References.vue';
import { isMobile } from 'mobile-device-detect';

const isFaceted = ref(false); // Track the current view state (stacked or faceted)
const selectedView = ref("stacked"); // Tracks the dropdown selection
const mobileView = isMobile; // Detect mobile view for responsive design

// Global variables to hold chart elements and data
let svg, chartBounds, rectGroup, useAxis, yearAxis;
let categoryGroups, yearGroups, stackedData;
let yearScale, useScale, categoryRectGroups;

// Adjust margins to equalize space
const labelWidth = 30; // Estimated width of the "mgd" label
const containerWidth = Math.min(window.innerWidth * 0.8, 800); // Constrain to 700px max
const containerHeight = mobileView ? window.innerHeight * 0.85 : 700;

const margin = mobileView
  ? { top: 60, right: 10, bottom: 50, left: 40 } // Increased bottom margin for mobile
  : { top: 80, right: labelWidth + 20, bottom: 60, left: 100 }; // Increased bottom margin for desktop

const width = containerWidth - margin.left - margin.right;
const height = containerHeight - margin.top - margin.bottom;

// Define toggle functions for switching between
function toggleToFaceted() {
  if (!isFaceted.value) {
    isFaceted.value = true;
    transitionToFaceted();
  }
}

function toggleToStacked() {
  if (isFaceted.value) {
    isFaceted.value = false;
    transitionToStacked();
  }
}

// Handle dropdown selection change
function handleViewChange() {
  if (selectedView.value === "faceted") {
    toggleToFaceted();
  } else {
    toggleToStacked();
  }
}

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
    .padding(0.02);

  // y-axis (water use scale)
  useScale = d3.scaleLinear()
    .domain([0, d3.max(stackedData, d => d3.max(d, d => d[1]))])
    .range([height, 0]);

  // Custom x-axis tick format: show every other year on mobile, all years on desktop
  const xAxisTickFormat = (year) => {
    return mobileView ? (year % 2 === 0 ? year : '') : year;
  };

// Create x-axis and apply the custom tick format
  chartBounds.append('g')
  .attr('class', 'x-axis')
  .attr('transform', `translate(0, ${height})`)
  .call(d3.axisBottom(yearScale)
    .tickFormat(xAxisTickFormat) // Apply custom format based on mobile view
    .tickSize(0)
  )
  .attr('font-size', mobileView ? '1.4rem' : '1.4rem')
  .selectAll('.tick text')
  .style('text-anchor', 'middle') // Center align the labels
  .attr('dx', '-0.2em'); // Move labels slightly to the left

// Remove tick lines
  chartBounds.selectAll('.x-axis .tick line').remove();

  // y-axis (water use scale)
  categoryGroups.forEach((group, i) => {
    chartBounds.append('g')
      .attr('class', `y-axis y-axis-${i}`)
      .call(d3.axisLeft(useScale).ticks(4).tickFormat(d3.format("~s")))
      .attr('font-size', mobileView ? '1.4rem' : '1.4rem');
  });

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
      .attr('width', yearScale.bandwidth() - 5)
      .style('fill', d => colorScale(d.key)));

  // mgd label
  svg.append("text")
    .attr("class", "y-axis-label")
    .attr("x", margin.left / 2) // position to the upper left
    .attr("y", margin.top / 2)
    .attr("text-anchor", "left")
    .style("font-size", "2.5rem")
    .style("font-weight", "bold")
    .text("mgd");

  // written out mgd label
  svg.append("text")
    .attr("class", "y-axis-label-explained")
    .attr("x", (margin.left / 2) + labelWidth*2) 
    .attr("y", margin.top / 2)
    .attr("text-anchor", "left")
    .style("font-size", "2.5rem")
    .style("font-style", "italic")
    .style('font-weight', "300")
    .text("million gallons per day");
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

function transitionToFaceted() {
  const facetPadding = 30; // padding between facets
  const totalPadding = (categoryGroups.length - 1) * facetPadding; 
  const facetHeight = (height - totalPadding) / categoryGroups.length; // adjust facet height to include padding

  const t = d3.transition().duration(1000);

  // move each category to its own facet along the y-axis
  categoryGroups.forEach((group, i) => {
    // use the original dataset
    const groupData = data.value.filter(d => d.Use === group);

    // find max mgd by group
    const groupMaxMgd = d3.max(groupData, d => +d.mgd);

    // get group-specific y-scale using max mgd
    const groupScale = d3.scaleLinear()
      .domain([0, groupMaxMgd])
      .nice(3)
      .range([facetHeight, 0]);

    // transition the y-axis into place for each category group
    d3.select(`.y-axis-${i}`)
      .transition(t)
      .attr('transform', `translate(0, ${i * (facetHeight + facetPadding)})`)
      .call(d3.axisLeft(groupScale).ticks(3).tickFormat(d3.format("~s")));

       // transition the x-axis into place for each category group
    d3.select(`.x-axis-${i}`)
      .transition(t)
      .attr('transform', `translate(0, ${i * (facetHeight + facetPadding) + facetHeight})`)
      .call(d3.axisBottom(yearScale).tickSize(0))
      .selectAll('.tick line').remove();
      
    // move group to its own facet
    const groupSelection = d3.select(`g #${sanitizeSelector(group)}`)
      .transition(t)
      .attr('transform', `translate(0, ${i * (facetHeight + facetPadding)})`);

    // ensure the data is properly bound to each rect
    d3.select(`g #${sanitizeSelector(group)}`).selectAll('rect')
      .data(groupData)
      //.join(enter => enter.append('rect')) 
      .transition(t)
      .attr('x', d => yearScale(d.water_year)) 
      .attr('width', yearScale.bandwidth() - 5)
      .attr('y', d => groupScale(+d.mgd)) 
      .attr('height', d => facetHeight - groupScale(+d.mgd)) 
      .style('fill', categoryColors[group]); 

    // add label for grouping
    chartBounds.append('text')
      .attr("class", "facet-label")
      .attr('x', 5)       
      .attr('y', i * (facetHeight + facetPadding + 5))  
      .attr('text-anchor', 'start')  
      .attr('font-weight', '600')
      .style('font-size', '1.5rem')   
      .text(group);       

  });

}

// transition the chart back to a stacked view
function transitionToStacked() {
  const t = d3.transition().duration(1000);

   // transition the bars back to the stacked position
   categoryRectGroups 
    .data(stackedData) // bind stacked data to groups
    .transition(t) 
    .attr('transform', 'translate(0, 0)'); // reset facet-specific transforms

  categoryRectGroups.selectAll('rect') 
    .data(d => d) // re-bind the stacked data to the rects
    .transition(t) 
    .attr('x', d => yearScale(d.data[0])) // re-position x
    .attr('y', d => useScale(d[1])) // stacked y-position (top of bar)
    .attr('height', d => useScale(d[0]) - useScale(d[1])) 
    .attr('width', yearScale.bandwidth() - 5); 

  // transition the 4 y-axes back to overlap on top of each other
  categoryGroups.forEach((group, i) => {
    d3.select(`.y-axis-${i}`)
      .transition(t)
      .attr('transform', 'translate(0, 0)')
      .call(d3.axisLeft(useScale)
        .ticks(4)
        .tickFormat(d3.format("~s"))
      );
  });

  // transition the 4 x-axes back to overlap on top of each other
  categoryGroups.forEach((group, i) => {
    d3.select(`.x-axis-${i}`)
      .transition(t)
      .attr('transform', `translate(0, ${height})`)
      .call(d3.axisBottom(yearScale).tickSize(0))
      .selectAll('.tick line').remove();
  });

  d3.selectAll('text.facet-label') 
    .transition(t)
    .style('opacity', 0) 
    .remove();
  
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
#barplot-container {
  max-width: 800px;
  width: 100%;
  margin: auto;
  display: flex;
  justify-content: center;
}

.dropdown-container {
  display: flex;
  justify-content: center;
  margin: 20px 0;
  width: 100%;
  text-align: center;
}

.dropdown-container select {
  padding: 10px 20px;
  font-size: 2rem;
  font-weight: 300;
  color: rgb(54, 53, 53);
  border: 1px solid rgb(54, 53, 53);
  border-radius: 8px;
  cursor: pointer;
  background-color: transparent;
  display: inline-block;
}

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
  &#Thermoelectric_fresh {
    background-color: #0B2F9F;
  }
  &#Thermoelectric_saline {
    background-color: #6CBEC7;
  }
}
</style>