<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
          <div class="chart-title-container">
            <p class="chart-title">Threats to surface water</p>
            <p class="chart-subtitle">The top threats to surface water used for drinking water, fish consumption, or recreational use by the proportion of total river miles</p>
          </div>
          <div class="viz-container">
            <div ref="heatmapSVG" id="heatmap-svg"></div>
          </div>
                    <!-- Category of use -->
          
            <div class="caption-container">
              <div class="checkbox_item">
                  <div class="checkbox_wrap">
                    <label class="toggle-text">
                      <input type="radio" name="threats" @click="toggleUse('DW')" checked="checked"> Drinking water
                    </label>
                    <label class="toggle-text">
                      <input type="radio" name="threats" @click="toggleUse('Fish')"> Fish consumption
                    </label>
                    <label class="toggle-text">
                      <input type="radio" name="threats" @click="toggleUse('Rec')"> Recreation
                    </label>
                  </div>
                </div>

              <div class="caption-text-child">
                <p>Heatmap showing the proportion of river miles that are threatened by different categories of contamination. Darker fills represent a higher proportion of river miles threatened by that source. Select a column name to short the rectangles from highest proportion to lowest for that category of use.</p>
                <br>
              </div>
            </div>
            <div class="text-container">
              <p>Surface water is the drinking-water source for about two-thirds of the Nation's population. In addition, surface water provides important ecosystem services for humans, including sourcing fish for consumption and providing recreational benefit. </p>
              <h4>Threats to surface water from metals</h4>
              <p>Iron, selenium, arsenic, lead, and copper are the top non-mercury metals impairing rivers and streams across the United States (US EPA, 2023). These types of metals occur naturally in surface water from geogenic sources such as rock weathering and soil erosion. Human activities like mining, urban runoff, wastewater, fertilizer and pesticide use, fuel combustion, and nuclear reactions can also add substantial volumes of metals to the environment above background levels.</p>
              <br>
              <p>Mercury can harm aquatic organisms and limit the amount of fish and other aquatic species that are safe for humans to eat. Mercury has geogenic sources (volcanoes, hot springs, geologic deposits, and the ocean) and anthropogenic sources (industrial processes, mining, and coal combustion). Dispersion of mercury through the atmosphere has resulted in widespread occurrence of mercury in the environment. Young children and developing fetuses are particularly vulnerable to mercury exposure through fish consumption. </p>
              <h4>Threats to surface water from salinity</h4>
              <p>Salinity is sourced from natural sources, such as groundwater, saline springs, and rock formations, as well as by human sources, such as irrigation, urbanization, pasture, and road deicers. Salinity can cause considerable local issues for human beneficial uses and ecosystem needs. Over one-third of the drainage area of the lower 48 states has experienced salinization, primarily in the populated Northeast through Midwest aggregated hydrologic regions (Kaushal et al., 2018; Cañedo-Argüelles, 2020). Trend assessments at many sites across the United States show increasing salinity over time, particularly in urban areas, and at concentrations that indicate potential corrosion of drinking-water infrastructure (Stets et al. 2020).</p>
              <h4>Threats to surface water from PCBs</h4>
              <p>PCBs are endocrine-disrupting compounds that were once commonly used in industry and commercial products and are associated a wide range of human-health risks. PCBs are persistent in the environment and can bioaccumulate in aquatic organisms and food webs (Ngoubeyou et al., 2022), leading to concerns for ecological and recreational uses and hazards to human health through fish consumption. Although PCBs were prohibited decades ago, PCB contamination can be common in industrial sites and hydrologically connected locations. About 30% of the historical worldwide production of PCBs is still present in aquatic ecosystems, sediments, and aquatic food webs (Ngoubeyou et al., 2022).</p>
              <h4>Threats to surface water from pathogens</h4>
              <p>Microbial pathogens like bacteria primarily threaten human health through ingestion and recreational activities like swimming (U.S. Environmental Protection Agency, 2023c). Bacteria can originate from natural or human activities that cause contamination including wastewater treatment plant discharge, leaky septic systems, stormwater runoff, animal waste, and runoff from animal pastures, feedlots, or manure storage (Cabral, 2010; Verhougstraete et al., 2015; U.S. Environmental Protection Agency, 2020). Each year in the United States, an estimated 560,000 people suffer from moderate-to-severe waterborne infection and an estimated 1,200 people die from waterborne infections (Morris and Levine, 1995). Young children are particularly vulnerable to waterborne diseases.</p>
            </div>
            <div  class="text-container">
              <h2>Groundwater quality</h2>
              <p>The contaminants that are most commonly found at elevated or high-concentration in drinking-water aquifers are "geogenic," or sourced from geologic sources like bedrock. Elevated geogenic nutrient concentrations affect more than 30 million people. Five geogenic constituents (arsenic, manganese, strontium, radium, and radionuclides) each have a substantially larger area and larger population affected by elevated concentration than nitrate. The largest affected groundwater-dependent populations rely on three aquifers: the California Coastal Basin, Basin and Range basin-fill, and the Glacial aquifer (Belitz and others, 2022).</p>
            </div>
            
          <div class="chart-title-container">
              <p class="chart-title">Groundwater drinking contamination levels</p>
              <p class="chart-subtitle">Pie charts show the proportion of each aquifer with levels that exceed human-health guidelines for 16 drinking water contaminants</p>
          </div>
            <div class="map-container">
              <img class="map-overlay" 
              :src="imgSrc">
              <aquiferWedges id="aquifer-svg" />
            </div>
            <div class="caption-container">

              <div class="caption-legend-child">
                <div class="legend_item" id="legend-wq-high" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                    Exceeds benchmark
                  </label>
                </div>
                <div class="legend_item" id="legend-wq-mod" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                    Exceeds half of the benchmark
                  </label>
                </div>
                <div class="legend_item" id="legend-wq-low" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                    Does not exceed benchmark
                  </label>
                </div>
              </div>
              <div class="caption-text-child">
                <p>Pie charts showing the overall groundwater quality in principal aquifers of the lower 48 United States (cite chapter). The values shown in the pie chart represent the proportion of the aquifer under three categories of water quality relative to the human-health benchmark for drinking water. For this analysis, 16 contaminants were analyzed, including arsenic, manganese, lead, and nitrate. (cite chapter). Results for selected individual constituents are also accessible in an interactive searchable map (link).</p>
              </div>
            </div>
              <Methods></Methods>
              <References :theseReferences="referenceList"></References>
        </div>
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>


</template>

<script setup>
import { onMounted, ref, reactive, inject, watch  } from 'vue';
import { useRoute } from 'vue-router';
import * as d3 from 'd3';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import references from './../assets/text/references.js';
import References from '../components/References.vue';
import SubPages from '../components/SubPages';
import aquiferWedges from '@/assets/svgs/aquifers.svg';
import { isMobile } from 'mobile-device-detect';

// global objects
const baseURL = "https://labs.waterdata.usgs.gov/visualizations/images/water-availability/"
const publicPath = import.meta.env.BASE_URL;
const mobileView = isMobile;

// aquifer map settings
const defaultRegionID = "overview";
const imgSrc = ref(getImgURL(defaultRegionID)); 

// for preview site toggle
const featureToggles = inject('featureToggles');
const route = useRoute();

// References logic
// filter to this page's key message
const filteredMessages = SubPages.SubPages.filter(message => message.route === route.path);
const filteredReferences = filteredMessages[0].references;// extract list of references for this page
const refArray = references.key.sort((a, b) => a.authors.localeCompare(b.authors)); // Sort references
const theseReferences = refArray.filter((item) => filteredReferences.includes(item.refID)) // extract references that match the refID from global list
theseReferences.forEach((item, index) => { item.referenceNumber = `${index + 1}`; }); // add numbers
const referenceList = ref(theseReferences);

// Reactive data bindings 
const dataDW = ref([]);
const dataRec = ref([]);
const dataFish = ref([]);
const selectedUse = ref('Drinking Water'); // default region

const chartSVG = ref(null);
let chartDimensions;
let chartBounds;
let rectGroup;

const heatmapSVG = ref(null);
let svg;

// chart dimensions
const width = mobileView ? 400 : 700;
const height = 700;

// Run of show
onMounted(async () => {

  try {
        await loadDatasets();

        if (dataDW.value.length > 0) {
          // set up chart dimensions
          chartDimensions = {
                    width: width,
                    height: height,
                    margin: {
                        top: mobileView ? 60 : 50,
                        right: mobileView ? 10 : 10,
                        bottom: mobileView ? 0 : 0,
                        left: mobileView ? 145 : 145
                    },
                }
                chartDimensions.boundedWidth = chartDimensions.width - chartDimensions.margin.left - chartDimensions.margin.right,
                chartDimensions.boundedHeight = chartDimensions.height - chartDimensions.margin.top - chartDimensions.margin.bottom

                // build charts
                setupSVG();
                initHeatmap({
                  dataset: dataDW.value.concat(dataFish.value, dataRec.value),
                  sortBy: 'DW'
                });
                updateHeatmap();

              } else {
                console.error('Error loading data');
            }
        } catch (error) {
            console.error('Error during component mounting', error);
        }

    // for aquifer pie chart
    addInteractions();
});

// METHODS
// general data loading fxn
async function loadDatasets() { // Created from R pipeline
  try {
    dataDW.value = await loadData('wq_threats_DW.csv');
    dataRec.value = await loadData('wq_threats_Rec.csv');
    dataFish.value = await loadData('wq_threats_Fish.csv');
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

function toggleUse(value) {
  console.log(value)
  initHeatmap({
    dataset: dataDW.value.concat(dataFish.value, dataRec.value),
    sortBy: value
  });
}



// create svg only once
function setupSVG() {

    // remove any existing SVG before redrawing
    d3.select('#heatmap-svg').select('svg').remove();

  svg = d3.select("#heatmap-svg")
    .append('svg')
    .attr('width', chartDimensions.width)
    .attr('height', chartDimensions.height)
    .attr('viewBox', `0 0 ${chartDimensions.width} ${chartDimensions.height}`);
  
  // Add group to chart bounds to hold all chart rectangle groups
    rectGroup = svg.append('g')
      .attr('id', 'rectangle_group')
}

// Initialize Legend
function initHeatmap({dataset, sortBy}) {

  // change order of threats for each use category
  const sortRank = dataset.filter(dataset => dataset.UseAbbr === sortBy);
  
  // sort dataset based on sortOrder
  const sortedDataset = dataset.sort((a, b) => a.sortOrder - b.sortOrder)

  const xScale = d3.scaleBand()
    .domain(sortedDataset.map(d => d.Use))
    .range([chartDimensions.margin.left, chartDimensions.width - chartDimensions.margin.right])

  const yScale = d3.scaleBand()
    .domain(sortRank.map(d => d.Parameter)) // uses rank based on selected use
    .range([chartDimensions.boundedHeight, chartDimensions.margin.top])
    .padding(0.1);

  const yAxis = d3.axisLeft(yScale)
    .tickSizeOuter(0)

  const colorScale = d3.scaleLinear()
    .range(["#F4E0AF", "#482F0F"])
    .domain([1, 26])

  // set up transition timing
  const dur = 1000;
  const t = d3.transition().duration(dur);

   // Create a bar for each category.
   const bar = rectGroup.append("g")
      .selectAll("rect")
        .data(sortedDataset)
        .join(
          enter => enter.append("rect")
            .attr("x", d => xScale(d.Use))
            .attr("y", d => yScale(d.Parameter))
            .attr('width', xScale.bandwidth())
            .attr('height', yScale.bandwidth())
            .style("fill", d => colorScale(d.percentMiles))
            .transition(t),

          update => update.transition(t),

          exit => exit.transition(t)
            .style("opacity", 0)
            .remove()
        );

        // Append a label for each rect
    svg.selectAll("#percent-labels").remove()
    svg.append("g")
      .attr("text-anchor", "end")
      .selectAll()
      .data(sortedDataset)
        .join(
          enter => enter.append("text")
            .attr("class", "chart-text")
            .attr("id", "percent-labels")
            .attr("x", (d) => xScale(d.Use) + xScale.bandwidth())
            .attr("y", (d) => yScale(d.Parameter) + yScale.bandwidth() / 2)
            .attr("dy", "0.35em")
            .attr("dx", -4)
            .text((d) => d.percentMiles + '%')
            .style("fill", function(d) {
                    return d.percentMiles > 15 ? "white" : "black";
                  })
            .transition(t),
          
          update => update.transition(t),

          exit => exit.transition(t)
            .style("opacity", 0)
            .remove()
        );

      // Create the axes.
    svg.append("g")
        .attr("transform", `translate(0,${chartDimensions.margin.top})`)
        .call(d3.axisTop(xScale).ticks(3))
        .call(g => g.select(".domain").remove())
        .attr("class", "chart-text");

    svg.select("#y-axis").remove();

    svg.append("g")
        .attr("transform", `translate(${chartDimensions.margin.left},0)`)
        .call(d3.axisLeft(yScale).tickSizeOuter(0))
        .attr("class", "chart-text")
        .attr("id", "y-axis");
  

    

}
// Enter update for sorting
function updateHeatmap() {
  console.log("update called")
}


// Methods for aquifer map
function addInteractions() {
        // set viewbox for svg with wedges
        const aquiferSVG = d3.select("#aquifer-svg")
            .attr("viewBox", "0 0 " + 2700 + " " + 1800)
            .attr("preserveAspectRatio", "xMidYMid meet")
            .attr("width", '100%')
            .attr("height", '100%')
        
        // Add interaction to wedges
        aquiferSVG.selectAll('.st0')
            .on("mouseover", (event) => mouseoverMap(event))
            .on("mouseout", (event) => mouseoutMap(event))

        // Add mouseleave to wrapper, which is a group that contains the wedges
        aquiferSVG.selectAll('#wrapper')
            .on("mouseleave", mouseleaveWrapper)

};

function getImgURL(id) {
  return new URL(`${baseURL}06_wq_gw_${id}.png`);
}

function mouseoverMap(event) {
  const regionID = event.target.id;
  imgSrc.value = getImgURL(regionID)
};

function mouseoutMap(event) {
  const regionID = event.target.id;
  imgSrc.value = getImgURL(defaultRegionID)
};

function mouseleaveWrapper() {
    // Show the default map
    const defaultMap = document.querySelector('#region-map-default');
    defaultMap.classList.remove("hide");

    // Make all wedges transparent
    d3.selectAll(".wedge").selectAll('polygon')
        .style("fill-opacity", 0)
};


</script>

<style scoped>


.map-container {
  position: relative;
  display: grid;
  margin: 0 auto 0 auto;
  grid-template-columns: minmax(50vw, 100%);
  grid-template-rows:  minmax(20vh, 600px);
  grid-template-areas:
      "overlay-maps";
}
.map-overlay {
  grid-area: overlay-maps;
  place-self: center;
  max-width: 100%;
  max-height: 100%;
}
#aquifer-svg {
  grid-area: overlay-maps;
  place-self: center;
  width: 100%;
  height: 100%;
  fill-opacity: 0;
}

</style>