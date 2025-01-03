<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">

          <SortingHeatMap 
            categoricalVariable="Parameter"
            colorVariable="Category"
            continuousRaw="riverMiles"
            :layerPaths="{
                OtherMetals: { path: layers.OtherMetals.path, color: layers.OtherMetals.color, orderDW: layers.OtherMetals.orderDW },
                Ammonia: { path: layers.Ammonia.path, color: layers.Ammonia.color, order: layers.Ammonia.orderDW }
              }"
            :dataDW="dataDW"
            :dataRec="dataRec"
            :dataFish="dataFish"
            :useName="selectedUse"
            />
            
            <div class="text-container">
              <p id="category-label"> Hover to view category names </p>
            </div>
            <div class="viz-container">
              <div class="treemap-container-mobile" >
                <treemapSVGmobile id="treemap-svg"></treemapSVGmobile>
              </div>
            </div>
            <div class="caption-container">
              <div class="caption-text-child">
                <p>These visualizations show the number of river miles that are threatened by different categories of contamination (left side), plus those that are considered unimpaired (XXX). Each larger threat is broken down into its consituents (right side). The threats are sorted on each side by the number of river miles, with the largest categories toward the top.</p>
              </div>
              <div class="caption-legend-child">
                <div class="legend_item" id="legend-wq-unimpaired" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                    Unimpaired water
                  </label>
                </div>
                <div class="legend_item" id="legend-wq-biotic" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                    Biotic
                  </label>
                </div>
                <div class="legend_item" id="legend-wq-nutrients" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                    Nutrients
                  </label>
                </div>
                <div class="legend_item" id="legend-wq-organics" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                    Organics
                  </label>
                </div>
                <div class="legend_item" id="legend-wq-metal" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                    Metals
                  </label>
                </div>
                <div class="legend_item" id="legend-wq-sediment" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                    Sediment
                  </label>
                </div>
                <div class="legend_item" id="legend-wq-salinity" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                    Salinity
                  </label>
                </div>
                <div class="legend_item" id="legend-wq-temp" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                    Temperature
                  </label>
                </div>
              </div>
            </div>
            <div class="text-container">
              <h3>Surface water quality</h3>
              <p>Surface water is the drinking-water source for about two-thirds of the Nation's population. In addition, surface water provides important ecosystem services for humans, including sourcing fish for consumption and providing recreational benefit. </p>
            </div>
            <div class="text-container">
              <h4>Metals</h4>
              <p>Iron, selenium, arsenic, lead, and copper are the top non-mercury metals impairing rivers and streams across the United States (US EPA, 2023). These types of metals occur naturally in surface water from geogenic sources such as rock weathering and soil erosion. Human activities like mining, urban runoff, wastewater, fertilizer and pesticide use, fuel combustion, and nuclear reactions can also add substantial volumes of metals to the environment above background levels.</p>
              <h4>Salinity</h4>
              <p>Salinity is sourced from natural sources, such as groundwater, saline springs, and rock formations, as well as by human sources, such as irrigation, urbanization, pasture, and road deicers. Salinity can cause considerable local issues for human beneficial uses and ecosystem needs. Over one-third of the drainage area of the lower 48 states has experienced salinization, primarily in the populated Northeast through Midwest aggregated hydrologic regions (Kaushal et al., 2018; Cañedo-Argüelles, 2020). Trend assessments at many sites across the United States show increasing salinity over time, particularly in urban areas, and at concentrations that indicate potential corrosion of drinking-water infrastructure (Stets et al. 2020).</p>
              <h4>Mercury</h4>
              <p>Mercury can harm aquatic organisms and limit the amount of fish and other aquatic species that are safe for humans to eat. Mercury has geogenic sources (volcanoes, hot springs, geologic deposits, and the ocean) and anthropogenic sources (industrial processes, mining, and coal combustion). Dispersion of mercury through the atmosphere has resulted in widespread occurrence of mercury in the environment. Young children and developing fetuses are particularly vulnerable to mercury exposure through fish consumption. </p>
              <h4>PCBs</h4>
              <p>PCBs are endocrine-disrupting compounds that were once commonly used in industry and commercial products and are associated a wide range of human-health risks. PCBs are persistent in the environment and can bioaccumulate in aquatic organisms and food webs (Ngoubeyou et al., 2022), leading to concerns for ecological and recreational uses and hazards to human health through fish consumption. Although PCBs were prohibited decades ago, PCB contamination can be common in industrial sites and hydrologically connected locations. About 30% of the historical worldwide production of PCBs is still present in aquatic ecosystems, sediments, and aquatic food webs (Ngoubeyou et al., 2022).</p>
              <h4>Pathogens</h4>
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
import SortingHeatMap from '../components/SortingHeatMap.vue';
import references from './../assets/text/references.js';
import References from '../components/References.vue';
import SubPages from '../components/SubPages';
import aquiferWedges from '@/assets/svgs/aquifers.svg';
import treemapSVGmobile from '@/assets/svgs/treemap_mobile.svg';
const publicPath = import.meta.env.BASE_URL;



// Reactive data bindings 
const dataDW = ref([]);
const dataRec = ref([]);
const dataFish = ref([]);
const selectedUse = ref('Drinking Water'); // default region

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

// global objects
const baseURL = "https://labs.waterdata.usgs.gov/visualizations/images/water-availability/"

// Colors for threat categories, Needs to be updated with CSS for text legend
// props for regionMap with toggleable layers
const layers = reactive({
  OtherMetals: {
    color: 'var(--wq-metals)', // css color for layer variable
    orderDW: 1, // order of color in stacked bar chart when drinking water is selected
    orderRec: 4, //
    orderFish: 5
  },  
  Salinity: {
    color: 'var(--wq-salinity)', // css color for layer variable
    orderDW: 2, // order of color in stacked bar chart when drinking water is selected
    orderRec: 10, //
    orderFish: 14
  },
  Sediment: {
    color: 'var(--wq-sediment)', // css color for layer variable
    orderDW: 3, // order of color in stacked bar chart when drinking water is selected
    orderRec: 6, //
    orderFish: 10
  },
  Temperature: {
    color: 'var(--wq-temp)', // css color for layer variable
    orderDW: 4, // order of color in stacked bar chart when drinking water is selected
    orderRec: 7, //
    orderFish: 7
  },
  Pathogens: {
    color: 'var(--wq-biotic)', // css color for layer variable
    orderDW: 5, // order of color in stacked bar chart when drinking water is selected
    orderRec: 1, //
    orderFish: 3
  },
  OxygenDepletion: {
    color: 'var(--wq-metals)', // css color for layer variable
    orderDW: 6, // order of color in stacked bar chart when drinking water is selected
    orderRec: 3, //
    orderFish: 6
  },
  OtherNutrients: {
    color: 'var(--wq-nutrients)', // css color for layer variable
    orderDW: 7, // order of color in stacked bar chart when drinking water is selected
    orderRec: 2, //
    orderFish: 9
  },
  Turbidity: {
    color: 'var(--wq-sediment)', // css color for layer variable
    orderDW: 8, // order of color in stacked bar chart when drinking water is selected
    orderRec: 8, //
    orderFish: 11
  },
  AciditypH: {
    color: 'var(--wq-metals)', // css color for layer variable
    orderDW: 9, // order of color in stacked bar chart when drinking water is selected
    orderRec: 12, //
    orderFish: 8
  },
  Pesticides: {
    color: 'var(--wq-organics)', // css color for layer variable
    orderDW: 10, // order of color in stacked bar chart when drinking water is selected
    orderRec: 11, //
    orderFish: 4
  },
  Mercury: {
    color: 'var(--wq-metals)', // css color for layer variable
    orderDW: 11, // order of color in stacked bar chart when drinking water is selected
    orderRec: 9, //
    orderFish: 2
  },
  PCBs: {
    color: 'var(--wq-metals)', // css color for layer variable
    orderDW: 12, // order of color in stacked bar chart when drinking water is selected
    orderRec: 5, //
    orderFish: 1
  },
  Biotoxins: {
    color: 'var(--wq-biotic)', // css color for layer variable
    orderDW: 13, // order of color in stacked bar chart when drinking water is selected
    orderRec: 13, //
    orderFish: 18
  },
  AlgalGrowth: {
    color: 'var(--wq-biotic)', // css color for layer variable
    orderDW: 14, // order of color in stacked bar chart when drinking water is selected
    orderRec: 14, //
    orderFish: 16
  },
  Dioxins: {
    color: 'var(--wq-organics)', // css color for layer variable
    orderDW: 15, // order of color in stacked bar chart when drinking water is selected
    orderRec: 15, //
    orderFish: 12
  },
  ToxicOrganics: {
    color: 'var(--wq-organics)', // css color for layer variable
    orderDW: 16, // order of color in stacked bar chart when drinking water is selected
    orderRec: 17, //
    orderFish: 13
  },
  Ammonia: {
    color: 'var(--wq-nutrients)', // css color for layer variable
    orderDW: 17, // order of color in stacked bar chart when drinking water is selected
    orderRec: 16, //
    orderFish: 15
  },
  OilandGrease: {
    color: 'var(--wq-organics)', // css color for layer variable
    orderDW: 18, // order of color in stacked bar chart when drinking water is selected
    orderRec: 18, //
    orderFish: 17
  },
});

// data for D3 charts
const csvDW = 'wq_threats_DW.csv' // stacked bar chart data
const csvRec = 'wq_threats_Rec.csv'
const csvFish = 'wq_threats_Fish.csv'


// Run of show
onMounted(async () => {

    // first load the data
    dataDW.value = await loadData(csvDW); // drinking water data
    dataRec.value = await loadData(csvRec);  // recreation data
    dataFish.value = await loadData(csvFish) // fish data

    // for aquifer pie chart
    addInteractions()
});

// METHODS
// general data loading fxn
async function loadData(fileName) {
    try {
        const data = await d3.csv(publicPath + fileName, d => d);
        return data;
    } catch (error) {
        console.error(`Error loading data from ${fileName}`, error);
        return [];
    }
}

// Methods
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

        // set viewbox for svg with treemap
        const treemapSVG = d3.select("#treemap-svg")
          .attr("viewBox", "0 0 " + 400 + " " + 661)
          .attr("preserveAspectRatio", "xMidYMid meet")
          .attr("width", '100%')
          .attr("height", '100%')

        // Add interaction to wedges
        treemapSVG.selectAll('.st0, .st1, .st2, .st3, .st4, .st5, .st6, .st7')
          .on("mouseover", (event) => mouseoverTreemap(event))
          .on("mouseout", (event) => mouseoutTreemap(event))
};

function getImgURL(id) {
  return new URL(`${baseURL}06_wq_gw_${id}.png`);
}


function mouseoverMap(event) {
  const regionID = event.target.id;
  imgSrc.value = getImgURL(regionID)
};

function mouseoverTreemap(event) {
  const categoryID = event.target.id;
  const categorySpaces = categoryID.replace(/_/g, " ").replace(1, "").replace(2,"");
  const paragraph = document.getElementById("category-label");
  paragraph.innerHTML = categorySpaces;
  const category0 = `${categorySpaces}`.replace(/\s/g, "_")
  const category1 = `${categorySpaces}1`.replace(/\s/g, "_")
  const category2 = `${categorySpaces}2`.replace(/\s/g, "_")
  // select all objects of matching ids
  d3.select("#treemap-svg").selectAll('rect').style("opacity", 0.6)
  d3.select("#treemap-svg").selectAll(`#${category0}, #${category1}, #${category2}`)
    .style("opacity", 1)
}


function mouseoutMap(event) {
  const regionID = event.target.id;
  imgSrc.value = getImgURL(defaultRegionID)
};

function mouseoutTreemap(event) {
  const categoryID = event.target.id;

  const paragraphOut = document.getElementById("category-label");
  paragraphOut.innerHTML = "Hover to view category names";
  d3.select("#treemap-svg").selectAll('rect').style("opacity", 1)
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
.treemap-container-mobile {
  width: 400px;
  height: 600px;
}
.treemap-container-desktop {
  width: 800px;
}


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



#DW-container, #fish-container, #rec-container {
  width: 100%;
  height: 100%;
  max-width: 800px;
}

.sankey-container {
  width: 80%;
  min-width: 600px;
  margin: 0 auto;
  padding-top: 20px;
}
@media only screen and (max-width: 768px) {
  .sankey-container {
    width: 90%;
    min-width: 200px;
  }
}
.sankey-tab-container {
  width: 90%;
  margin: 0 auto;
}

</style>
<style lang="scss">
  .axis-value {
    fill-opacity: 0.7;
  }
</style>