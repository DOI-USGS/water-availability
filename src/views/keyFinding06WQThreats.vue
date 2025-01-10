<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
          <div  class="text-container">
              <h2>Groundwater quality varies regionally</h2>
              <p>Groundwater is the drinking-water source for about one-third of the Nation's population. Geogenic contaiminants, which come from geologic sources like bedrock and sediment, are the most common contaminants found in drinking water aquifers at elevated or high concentrations. These geogenic contaminants affect more than 30 million people in the lower 48 United States.<span v-for="reference in theseReferences.filter(item => item.refID === 'Erickson2025')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }}, </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> <span v-for="reference in theseReferences.filter(item => item.refID === 'Belitz2022')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> What are geogenics? Geogenics are naturally occurring contaminants from geologic sources like bedrock and sediment. Five geogenic contaminants in particular (arsenic, manganese, strontium, radium, and radionuclides) affect a substantially large area and part of the population.</p>
            </div>
          <div class="chart-title-container">
              <p class="chart-title">Groundwater quality in {{ aquiferLabel }}</p>
              <p class="chart-subtitle">The proportion of each aquifer with contaminant levels that exceed human-health guidelines</p>
          </div>
            <div class="map-container">
              <img class="map-overlay" 
              :src="imgSrc">
              <aquiferWedges id="aquifer-svg" />
            </div>
            <div class="caption-container-flex caption-container">
              <div class="legend-group">
                <ColorLegend legend-id="legend-wq-high" label="Above human-health benchmark" color="var(--wq-high)" />
                <ColorLegend legend-id="legend-wq-mod" label="Exceeds half of the benchmark" color="var(--wq-mod)" />
                <ColorLegend legend-id="legend-wq-low" label="Normal levels" color="var(--wq-low)" />
                        </div>
              <div class="caption-text-flex caption-text-child">
                <p>Groundwater quality relative to the human-health benchmark for drinking water. For each principal aquifer in the lower 48 United States, a pie chart shows the proportion of the aquifer with contaminant levels for selected contaminants (including arsenic, manganese, lead, and nitrate).<span v-for="reference in theseReferences.filter(item => item.refID === 'Erickson2025')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }}, </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> <span v-for="reference in theseReferences.filter(item => item.refID === 'Belitz2022')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }}, </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> <span v-for="reference in theseReferences.filter(item => item.refID === 'Azadpour2025')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> <b>Select an aquifer on the map</b> to view a close-up of that aquifer's pie chart. To explore individual contaminants see these online maps (<a href="https://pubs.usgs.gov/pp/1894/c/pp1894c_index.html" target="_blank">link</a>).</p>
              </div>
            </div> 

            <div class="text-container" >
              <h2 class="spacer" style="padding-top:50px">Surface water quality varies by use</h2>
              <p>Surface water is the drinking-water source for about two-thirds of the Nation's population. In addition, surface water provides many benefits from sourcing fish for food to providing recreation. </p>
            </div>

            <div class="chart-title-container">
            <p class="chart-title">Top threats to surface water</p>
            <p class="chart-subtitle">Surface water threats based on the percent of total river miles impaired</p>
            <div class="checkbox_item">
                  <div class="checkbox_wrap">
                    <b class="toggle-text">Sort chart by: </b>
                    <label class="toggle-text">
                      <input type="radio" name="threats" class="radio-button" @click="toggleUse('DW')" checked="checked"> Drinking Water
                    </label>
                    <label class="toggle-text">
                      <input type="radio" name="threats" class="radio-button" @click="toggleUse('Fish')"> Fish Consumption
                    </label>
                    <label class="toggle-text">
                      <input type="radio" name="threats" class="radio-button" @click="toggleUse('Rec')"> Recreational Use
                    </label>
                  </div>
                </div>
          </div>
          <div class="viz-container">
            <div id="heatmap-svg"></div>
          </div>
                    <!-- Category of use -->
          
            <div class="caption-container">
              <div class="caption-text-child">
                <p>Heatmap of the top threats to drinking water, fish consumption, and recreational use. Chart fill and percentages show the percent of assessed river miles that are threatened by each contaminant. Darker fill indicates a higher degree of threat by that source.<span v-for="reference in theseReferences.filter(item => item.refID === 'EPA2023')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> <b>Toggle the options</b> to sort the chart by one of the three columns.</p>
                <br>
              </div>
            </div>
            <div class="text-container">
              
              <p>Surface water quality faces threats from metals, salinity, chemicals, and pathogens. Metals like iron, arsenic, and mercury come from geologic sources such as rocks and soil but can also enter water through mining, farming, and industry.<span v-for="reference in theseReferences.filter(item => item.refID === 'EPA2023')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> Too much salt, caused by natural processes and human activities (like irrigation and road deicers) can harm ecosystems and damage water pipes.<span v-for="reference in theseReferences.filter(item => item.refID === 'Stets2020')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> Harmful chemicals called PCBs (polychlorinated biphenyls) were banned years ago, however they still remain in rivers and lakes. PCBs build up in aquatic organisms, through food webs, accumulate in fish, and pose health risks to humans through fish consumption.<span v-for="reference in theseReferences.filter(item => item.refID === 'Ngoubeyou2022')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> Pathogens from wastewater, animal waste, and storm runoff can cause illnesses.<span v-for="reference in theseReferences.filter(item => item.refID === 'Cabral2010')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> Protecting surface water is important for safe drinking water, healthy ecosystems, and public health.</p>
          
            </div>
              <Methods :theseReferences="referenceList"></Methods>
              <References :theseReferences="referenceList"></References>
        </div>
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>


</template>

<script setup>
import { onMounted, ref, inject  } from 'vue';
import { useRoute } from 'vue-router';
import * as d3 from 'd3';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/MethodsSection.vue';
import references from './../assets/text/references.js';
import References from '../components/ReferencesSection.vue';
import SubPages from '../components/SubPages';
import aquiferWedges from '@/assets/svgs/aquifers.svg';
import ColorLegend from '../components/ColorLegend.vue';
import { isMobile } from 'mobile-device-detect';

// S3 resource sourcing
const s3ProdURL = import.meta.env.VITE_APP_S3_PROD_URL;

// global objects
const baseURL = s3ProdURL + "images/water-availability/"
const publicPath = import.meta.env.BASE_URL;
const mobileView = isMobile;

// aquifer map settings
const defaultRegionID = "overview";
const imgSrc = ref(getImgURL(defaultRegionID)); 
let aquiferLabel = "principal aquifers of the lower 48 United States";
const aquiferCrosswalk = [
  { abbr: "cacb", name: "CA Coastal Basins"},
  { abbr: "cval", name: "Central Valley"},
  { abbr: "clpt", name: "Colorado Plateau"},
  { abbr: "bnrf", name: "Basin and Range Fill"},
  { abbr: "bnrc", name: "Basin and Range Carbonates"},
  { abbr: "copl", name: "Columbia Plateau Basalts"},
  { abbr: "hpaq", name: "High Plains"},
  { abbr: "strv1", name: "Stream Valley West"},
  { abbr: "rgaq", name: "Rio Grande"},
  { abbr: "edtr", name: "Edwards Trinity"},
  { abbr: "ozrk", name: "Ozarks"},
  { abbr: "metx", name: "MS Embayment, TX Coastal Uplands"},
  { abbr: "secp", name: "Southeast Coastal Plain"},
  { abbr: "strv2", name: "Stream Valley East"},
  { abbr: "cmor", name: "Cambrian Ordovician"},
  { abbr: "glac", name: "Glacial"},
  { abbr: "vpdc", name: "Valley and Ridge, Piedmont and Blue Ridge"},
  { abbr: "pied", name: "Piedmont Blue Ridge Crystalline"},
  { abbr: "nacp", name: "North Atlantic Coastal Plain"},
  { abbr: "surf", name: "Surficial"},
  { abbr: "bisc", name: "Biscayne"},
  { abbr: "flor", name: "Floridan"},
  { abbr: "clow", name: "Coastal Lowlands"}
];
        

// for preview site toggle
const featureToggles = inject('featureToggles');
const route = useRoute();

// References logic
// filter to this page's key message
const filteredMessages = SubPages.SubPages.filter(message => message.route === route.path);
const filteredReferences = filteredMessages[0].references;// extract list of references for this page
const theseReferences = references.key.filter((item) => filteredReferences.includes(item.refID)) 
// sort by order listed on page, reflected in list on subpages.js
const sortedReferences = theseReferences.sort((a, b) => filteredReferences.indexOf(a.refID) - filteredReferences.indexOf(b.refID))
sortedReferences.forEach((item, index) => { item.referenceNumber = `${index + 1}`; }); // add numbers
const referenceList = ref(sortedReferences);

// Reactive data bindings 
const dataDW = ref([]);
const dataRec = ref([]);
const dataFish = ref([]);


let chartDimensions;
let rectGroup;

let svg;

// chart dimensions
const width = mobileView ? 400 : 700;
const height = 650;

// Run of show
onMounted(async () => {

  window.scrollTo(0, 0);
  
  try {
        await loadDatasets();

        if (dataDW.value.length > 0) {
          // set up chart dimensions
          chartDimensions = {
                    width: width,
                    height: height,
                    margin: {
                        top: mobileView ? 30 : 30,
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
    .range([chartDimensions.height-chartDimensions.margin.bottom, chartDimensions.margin.top])
    .padding(0.1);

  d3.axisLeft(yScale)
    .tickSizeOuter(0)

  const colorScale = d3.scaleLinear()
    .range(["#F4E0AF", "#482F0F"])
    .domain([1, 26])

  // set up transition timing
  const dur = 1000;
  const t = d3.transition().duration(dur);

   // Create a bar for each category.
   rectGroup.append("g")
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
        .attr("class", "chart-text")
        .style('font-weight', '700');

    svg.select("#y-axis").remove();

    svg.append("g")
        .attr("transform", `translate(${chartDimensions.margin.left},0)`)
        .call(d3.axisLeft(yScale).tickSizeOuter(0))
        .attr("class", "chart-text")
        .attr("id", "y-axis");
  

    

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
            .on("mouseout", mouseoutMap)

        // Add mouseleave to wrapper, which is a group that contains the wedges
        aquiferSVG.selectAll('#wrapper')
            .on("mouseleave", mouseleaveWrapper)

};

function getImgURL(id) {
  return new URL(`${baseURL}06_wq_gw_${id}.png`);
}

function mouseoverMap(event) {
  const regionID = event.target.id;
  imgSrc.value = getImgURL(regionID);
  const matchAquifer = aquiferCrosswalk.find(element => element.abbr === regionID)
  aquiferLabel = "the " + matchAquifer.name + " Aquifer"
};

function mouseoutMap() {
  imgSrc.value = getImgURL(defaultRegionID);
  aquiferLabel = "principal aquifers of the lower 48 United States"
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