<template>
  <section class="main-container">
    <KeyMessages></KeyMessages>
    <div class="content-container">
      <div class="text-container">
        <p>
          An understanding of where, when, why, and how much water is extracted for human use is fundamental to understanding the Nation's water availability. Around 90% of daily water use in the United States goes toward public supply, agriculture, and thermoelectric power generation. Most of our daily water use is for crop irrigation followed by fresh water used in the process of creating energy from thermoelectric power plants. Along with public supply, where water is withdrawn or purchased by a water supplier and delivered to many users, these three uses of water add up to 224,000 million gallons of water used per day in the United States. Thermoelectric power (from saline water) uses another approximately 21,000 million gallons per day. 
        </p>
      </div>

      <div class="viz-container">
        <div id="barplot-container"></div>
      </div>
      <div class="caption-container">
        <!-- Scale toggle -->
        <ToggleSwitch 
          v-model="isFaceted"
          leftLabel="Total use"
          rightLabel="Use by category"
          leftColor="black"
          rightColor="black"
        />
        <div class="caption-legend-child">
          <div class="legend_item" id="legend-wu-ir" >
            <label class="legend_wrap">
            <input type="legend" name="legend" class="legend-inp">
            <span class="legend_mark"></span>
              Crop irrigation
            </label>
          </div>
          <div class="legend_item" id="legend-wu-ps" >
            <label class="legend_wrap">
            <input type="legend" name="legend" class="legend-inp">
            <span class="legend_mark"></span>
              Public supply
            </label>
          </div>
          <div class="legend_item" id="legend-wu-te-fresh" >
            <label class="legend_wrap">
            <input type="legend" name="legend" class="legend-inp">
            <span class="legend_mark"></span>
              Thermoelectric (fresh)
            </label>
          </div>
          <div class="legend_item" id="legend-wu-te-saline" >
            <label class="legend_wrap">
            <input type="legend" name="legend" class="legend-inp">
            <span class="legend_mark"></span>
              Thermoelectric (saline)
            </label>
          </div>
          </div>
          <div class="caption-text-child">
          <p>Bar chart showing modeled total daily water use averaged by year from 2010 through 2020 for the lower 48 United States. Toggle between viewing the total annual use versus the annual use by category. Note that the y-scale is not constant across use categories when viewing use by category.</p>
        </div>
      </div>
      <div class="text-container">
        <p>
          Water use affects water availability in two ways. On the one hand, ensuring safe, sufficient, and reliable sources of water for human needs is a primary objective of water management. On the other hand, water withdrawals may decrease availability for downstream users and local ecosystems and can concentrate water quality contaminants. Therefore, areas with more intensive water demands have a higher potential to degrade the resource than areas with less intense water demands. 
        </p>
      </div>
      
      <div class="text-container">
        <p>Other categories of water use such as mining, aquaculture, livestock, and domestic and industrial (from non-public supply sources), that together account for 10% of water use in the country, can also be locally or regionally important.</p>
      </div>

      <div class="text-container">
        <h3>Not all the water withdrawn for human water use returns to the local environment</h3>
      </div>
      <div class="viz-container">
        <img class="viz-placeholder" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/07_consumptive_labels.png"/>
      </div>
      <div class="text-container">
        <p>Water that does not return to local water bodies or groundwater is lost to the atmosphere, consumed by humans or livestock, or incorporated into products or crops. Across the lower 48 United States, the proportion of water use consumed in these ways is 72% for irrigation, 12% for public supply, and 4% for thermoelectric power. </p>
      </div>
      
      <Methods></Methods>
      <References :theseReferences="referenceList"></References>
    </div>
    <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
  </section>
</template>

<script setup>
import { onMounted, ref, inject, watch, nextTick } from 'vue';
import { useRoute } from 'vue-router';
import * as d3 from 'd3';
import KeyMessages from '../components/KeyMessages.vue';
import PageCarousel from '../components/PageCarousel.vue';
import Methods from '../components/Methods.vue';
import references from './../assets/text/references.js';
import References from '../components/References.vue';
import SubPages from '../components/SubPages';
import { isMobile } from 'mobile-device-detect';
import ToggleSwitch from '../components/ToggleSwitch.vue';

// dependency injections
const featureToggles = inject('featureToggles');
const animateTime = inject('animateTime')

const route = useRoute();

// References logic
// filter to this page's key message
const filteredMessages = SubPages.SubPages.filter(message => message.route === route.path);
const filteredReferences = filteredMessages[0].references;// extract list of references for this page
const refArray = references.key.sort((a, b) => a.authors.localeCompare(b.authors)); // Sort references
const theseReferences = refArray.filter((item) => filteredReferences.includes(item.refID)) // extract references that match the refID from global list
theseReferences.forEach((item, index) => { item.referenceNumber = `${index + 1}`; }); // add numbers
const referenceList = ref(theseReferences);

// global objects
const isFaceted = ref(false); // Track the current view state (stacked or faceted)
const mobileView = isMobile; // Detect mobile view for responsive design

// Global variables to hold chart elements and data
let svg, chartBounds, rectGroup, useAxis, yearAxis, xAxisGroup;
let categoryGroups, yearGroups, dataStacked;
let yearScale, useScale, categoryRectGroups;
const containerWidth = 700; 
const containerHeight = 600;

// chart dimensions
const margin = mobileView
  ? { top: 80, right: 10, bottom: 50, left: 40 } //  mobile
  : { top: 80, right: 10, bottom: 50, left: 40 }; // desktop

const width = containerWidth - margin.left - margin.right;
const height = containerHeight - margin.top - margin.bottom;

// Define colors for each category group
const categoryColors = {
  'Public Supply': 'var(--wu-ps)',
  'Irrigation': 'var(--wu-agriculture)',
  'Thermoelectric (fresh)': 'var(--wu-te-fresh)',
  'Thermoelectric (saline)': 'var(--wu-te-saline)',
};

// Data references
const dataSet = ref([]);
const data = ref([]);

// Watcher to handle toggle changes
watch(isFaceted, (newValue) => {
  if (newValue) {
    transitionToFaceted();
  } else {
    transitionToStacked();
  }
});

// METHODS
// Helper function to create valid CSS selectors by replacing special characters
function sanitizeSelector(str) {
  return str.replace(/[ ()]/g, '_');
}

// Load the datasets and prep the data
async function loadDatasets() {
  try {
    const data_in = await d3.csv('wu_yearly.csv', d => d);

    // Extract unique categories and years
    categoryGroups = [...new Set(data_in.map(d => d.Use))];
    yearGroups = d3.union(data_in.map(d => d.water_year));

    // Stack the data for the stacked bar chart
    dataStacked = d3.stack()
      .keys(categoryGroups)
      .value(([, D], key) => D.get(key)['mgd'])
      (d3.index(data_in, d => d.water_year, d => d.Use));

    // assign data to reactive obj
    dataSet.value = data_in;

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

  xAxisGroup = chartBounds.append('g')
    .attr('class', 'x-axis') 
    .attr('transform', `translate(0, ${height})`); 
}

// Function to create the initial bar chart in stacked form
function createBarChart({ dataset, dataStacked }) {

  // X-axis (year scale)
  yearScale = d3.scaleBand()
    .domain(yearGroups)
    .range([0, width])
    .padding(0.02);

  // Custom x-axis tick format: show every other year on mobile, all years on desktop
  const xAxisTickFormat = (year) => {
    return mobileView ? (year % 2 === 0 ? year : '') : year;
  };

  // select x-axis and apply the custom tick format
  xAxisGroup.append('g')
    .call(d3.axisBottom(yearScale)
      .tickFormat(xAxisTickFormat) // Apply custom numbering format in mobile view
      .tickSize(0)
    )
    .selectAll('.tick text')
    .attr('class', 'chart-text')
    .style('text-anchor', 'middle')
    .attr('text-align', 'center') 

  // Remove tick lines from x-axis
  chartBounds.selectAll('.x-axis .tick line').remove();

  // y-axis (water use scale)
  useScale = d3.scaleLinear()
    .domain([0, d3.max(dataStacked, d => d3.max(d, d => d[1]))])
    .range([height, 0]);

  // add axis to chart
  categoryGroups.forEach((group, i) => {
    chartBounds.append('g')
      .attr('class', `y-axis y-axis-${i}`)
      .call(d3.axisLeft(useScale).ticks(4).tickFormat(d3.format("~s")))
      .selectAll('.tick text')
      .attr('class', 'chart-text');
  });

  // Create color scale for the bars
  const colorScale = d3.scaleOrdinal()
    .domain(categoryGroups)
    .range(categoryGroups.map(item => categoryColors[item]));

  // Create grouped bars for each category
  categoryRectGroups = rectGroup.selectAll('g')
    .data(dataStacked, d => d.key)
    .join(enter => enter.append('g')
    .attr('id', d => sanitizeSelector(d.key)));

  categoryRectGroups.selectAll('rect')
    .data(D => D.map(d => (d.key = D.key, d)))
    .join(enter => enter.append('rect')
      .attr('x', d => yearScale(d.data[0]))
      .attr('y', d => useScale(d[1]))
      .attr('height', d => useScale(d[0]) - useScale(d[1]))
      .attr('width', yearScale.bandwidth() - 5)
      .style('fill', d => colorScale(d.key)));

  // chart title
  svg.append("text")
    .attr("class", "chart-title")
    .attr("x", margin.left / 2) 
    .attr("y", margin.top / 2)
    .attr("text-anchor", "start")
    .text("Average daily water use");

  // chart subtitle
  svg.append("text")
    .attr("class", "chart-subtitle")
    .attr("x", margin.left/2) 
    .attr("y", margin.top-20)
    .attr("text-anchor", "start")
    .text("Bars show average daily water use (million gallons per day) for the lower 48 United States by use type");
}
function transitionToFaceted() {
  const t = d3.transition().duration(animateTime); // animation transition
  const padding = 30; // padding between facets

  // calculate max values for each group and total max for scaling
  const groupMaxValues = categoryGroups.map(group =>
    d3.max(data.value.filter(d => d.Use === group), d => +d.mgd)
  );

  // calculate proportional heights for each group
  const totalMaxValue = d3.sum(groupMaxValues);
  const facetHeights = groupMaxValues.map(max => (max / totalMaxValue) * height);

  // dynamically compute exact positions based on scaled heights
  let facetPositions = [];
  let currentPosition = 0;

  categoryGroups.forEach((group, i) => {
    // get dataset for the group
    const groupData = data.value.filter(d => d.Use === group);
    const groupMaxMgd = groupMaxValues[i];

    // compute y-scale for the group
    const groupScale = d3.scaleLinear()
      .domain([0, groupMaxMgd])
      .range([facetHeights[i], 0]);

    yearScale = d3.scaleBand()
      .domain(yearGroups) 
      .range([0, width]) 
      .padding(0.02); 


    // set position accounting for actual height and padding
    facetPositions.push(currentPosition);
    currentPosition += facetHeights[i] + padding; // add padding between groups

    // update y-axis position
    d3.select(`.y-axis-${i}`)
      .transition(t)
      .attr('transform', `translate(0, ${facetPositions[i]})`)
      .call(d3.axisLeft(groupScale).ticks(3).tickFormat(d3.format("~s")))
      .selectAll('.tick text')
      .attr('class', 'chart-text');

    // update bar group position
    d3.select(`g #${sanitizeSelector(group)}`)
      .transition(t)
      .attr('transform', `translate(0, ${facetPositions[i]})`);

    // update bars
    d3.select(`g #${sanitizeSelector(group)}`)
      .selectAll('rect')
      .data(groupData)
      .transition(t)
      .attr('x', d => yearScale(d.water_year))
      .attr('width', yearScale.bandwidth() - 5)
      .attr('y', d => groupScale(+d.mgd))
      .attr('height', d => facetHeights[i] - groupScale(+d.mgd))
      .style('fill', categoryColors[group]);

    // add group label
    chartBounds.append('text')
      .attr("class", "facet-label chart-text")
      .attr('x', 5)
      .attr('y', facetPositions[i] - 10) // place label above each group
      .attr('text-anchor', 'start')
      .text(group);
  });

  // resize the SVG height dynamically based on the total height
  // compute the total height needed for the facets
const totalHeight = facetPositions[facetPositions.length - 1] + facetHeights[facetHeights.length - 1];

// update x-axis position dynamically
xAxisGroup.select('x-axis').transition(t)
  .attr('transform', `translate(0, ${totalHeight})`) // move to the new position
  .call(d3.axisBottom(yearScale).tickSize(0)) // redraw axis
  .selectAll('.tick text')
  .attr('class', 'axis-text')
  .style('text-anchor', 'middle'); // ensure labels are styled


  // dynamically resize the SVG height to fit all groups and x-axis
svg.transition(t).attr('viewBox', `-40 0 ${containerWidth + 20} ${containerHeight + 100}`); // add 50px padding below x-axis

}

// transition the chart back to a stacked view
function transitionToStacked() {
  const t = d3.transition().duration(animateTime);

   // transition the bars back to the stacked position
   categoryRectGroups 
    .data(dataStacked) // bind stacked data to groups
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
      )
      .selectAll('.tick text')
      .attr('class', 'chart-text');
  });

  // transition the 4 x-axes back to overlap on top of each other
  categoryGroups.forEach((group, i) => {
    d3.select(`.x-axis-${i}`)
      .transition(t)
      .attr('transform', `translate(0, ${height})`)
      .call(d3.axisBottom(yearScale).tickSize(0))
      .selectAll('.tick line')
      .remove();
  });

 chartBounds.selectAll('.facet-label') 
    .transition(t)
    .style('opacity', 0) 
    .remove();

  xAxisGroup.transition(t)
    .attr('transform', `translate(0, ${height})`) // move back to bottom
    .call(d3.axisBottom(yearScale).tickSize(0))
    .selectAll('.tick text')
    .attr('class', 'axis-text')
    .style('text-anchor', 'middle');
  
}

// On mounted loads data and initializes the chart
onMounted(async () => {
  await loadDatasets();
  if (dataSet.value.length > 0) {
    data.value = dataSet.value;
    initBarChart();
    createBarChart({ dataset: data.value, dataStacked: dataStacked });

    // watch toggle AFTER initialization
    watch(isFaceted, (newValue) => {
      // ensure DOM updates complete first
      nextTick(() => {
        if (newValue) {
          transitionToFaceted(); // trigger faceted transition
        } else {
          transitionToStacked(); // trigger stacked transition
        }
      });
    });
  }
});

</script>

<style scoped>
#barplot-container {
  max-width: 100%;
  width: 100%;
  margin: auto;
  display: flex;
  justify-content: center;
}

</style>