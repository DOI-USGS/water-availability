<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <p>Water limitation is the balance between supply and demand (water use).<span v-for="reference in theseReferences.filter(item => item.refID === 'Stets2025')" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> Water supply is typically much higher than demand, with more than enough water available to meet our needs. In some drier parts of the U.S., like the Southwest and the High Plains, the differences between water supply and demand are smaller.  
                  </p>
            </div>
        <!-- Supply and Demand dumbell chart -->
        <div class="chart-title-container">
            <p class="chart-title">Water supply vs demand</p>
            <p class="chart-subtitle">Regional estimates in mm/year for supply (solid circle) and demand (hollow circle)</p>
            <!-- Supply and Demand dumbell toggles -->
             <div class="toggle-group">
              <ToggleSwitch 
                v-model="demandEnabled" 
                rightLabel="Water demand" 
                :rightColor="'var(--ws-demand)'"
              />
              <ToggleSwitch 
                v-model="supplyEnabled" 
                rightLabel="Water supply" 
                :rightColor="'var(--ws-demand)'"
              />
            </div>
          </div>
          <DumbellChart 
            :data="data" 
            :animateTime="animateTime"
            v-model:supplyEnabled="supplyEnabled" 
            v-model:demandEnabled="demandEnabled"
          /> 
        <div class="caption-container">
          <!-- Supply and Demand caption -->
          <div class="caption-text-child">
            <p>The average annual water supply and demand in millimeters per year from 2010 to 2020. Data are shown by hydrologic region.<span v-for="reference in theseReferences.filter(item => item.refID === 'VanMetre2020')" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> </p>
          </div>
        </div>
        <br>
        <br>

        <!-- Regional SUI section -->
        <div class="text-container">
          <h2>Does this mean we have enough water?</h2>
        <p>
          When demand approaches supply, water becomes limited. At local and regional scales, water limitation impacts human and ecosystem needs. Between 2010 and 2020, significant portions of the Southern High Plains, Central High Plains, Texas, Mississippi Embayment, and Southwest Desert regions had widespread local water limitation. Future population growth, increasing food demands, and climatic changes could drive further imbalance between supply and demand, exacerbating water limitation across the Nation. 
        </p>
        </div>
        <!-- Regional SUI map with updating stacked bar chart -->
        <div class="chart-title-container">
            <p class="chart-title">Water limitation in {{ selectedRegion !== 'lower 48 United States' ? selectedRegion + ' Region' : selectedRegion }}</p>
            <p class="chart-subtitle">Bars show the percent of the region with very low, low, moderate, high, and severe water limitation</p>
          </div>
        <div class="image-container">
          <StackedBar 
            categoricalVariable="d3_category"
            continuousRaw="stress_by_reg"
            continuousPercent="d3_percentage"
            :layerPaths="{
            very_low_none: { path: layers.very_low_none.path, color: layers.very_low_none.color, order: layers.very_low_none.order },
            low: { path: layers.low.path, color: layers.low.color, order: layers.low.order },
            moderate: { path: layers.moderate.path, color: layers.moderate.color, order: layers.moderate.order },
            high: { path: layers.high.path, color: layers.high.color, order: layers.high.order },
            severe: { path: layers.severe.path, color: layers.severe.color, order: layers.severe.order },
          }"
            :data="csvData"
            :regionName="selectedRegion"
            />
          <RegionMap 
          @regionSelected="updateSelectedRegion"
          :layerVisibility="{
            very_low_none: layers.very_low_none.visible,
            low: layers.low.visible,
            moderate: layers.moderate.visible,
            high: layers.high.visible,
            severe: layers.severe.visible,
          }"
          :layerPaths="{
            very_low_none: { path: layers.very_low_none.path, color: layers.very_low_none.color, order: layers.very_low_none.order },
            low: { path: layers.low.path, color: layers.low.color, order: layers.low.order },
            moderate: { path: layers.moderate.path, color: layers.moderate.color, order: layers.moderate.order },
            high: { path: layers.high.path, color: layers.high.color, order: layers.high.order },
            severe: { path: layers.severe.path, color: layers.severe.color, order: layers.severe.order },
          }"
          regionsDataUrl="assets/Regions.topojson"
          usOutlineUrl="assets/USoutline.topojson"
          regionsVar="Region_nam_nospace"
          layerMag="1.2"
          layerX="-80"
          layerY="-55"

        />
        </div>
        <!-- SUI category on and off toggles -->
        <div class="caption-container-flex caption-container">
          <div class="toggle-group">
          <b>Water limitation</b> 
              <!-- Very Low -->
              <ToggleSwitch 
                v-model="veryLowEnabled" 
                rightLabel="Very low (0 - 0.2)" 
                :rightColor="layers.very_low_none.color"
                @update:modelValue="toggleLayer('very_low_none')" 
              />

              <!-- Low -->
              <ToggleSwitch 
                v-model="lowEnabled" 
                rightLabel="Low (0.2 - 0.4)" 
                :rightColor="layers.low.color"
                @update:modelValue="toggleLayer('low')" 
              />

              <!-- Moderate -->
              <ToggleSwitch 
                v-model="moderateEnabled" 
                rightLabel="Moderate (0.4 - 0.6)" 
                :rightColor="layers.moderate.color"
                @update:modelValue="toggleLayer('moderate')" 
              />

              <!-- High -->
              <ToggleSwitch 
                v-model="highEnabled" 
                rightLabel="High (0.6 - 0.8)" 
                :rightColor="layers.high.color"
                @update:modelValue="toggleLayer('high')" 
              />

              <!-- Severe -->
              <ToggleSwitch 
                v-model="severeEnabled" 
                rightLabel="Severe (0.8 - 1.0)" 
                :rightColor="layers.severe.color"
                @update:modelValue="toggleLayer('severe')" 
              />
              </div>
              <div class="caption-text-flex caption-text-child">
                <br>
                <p>Water limitation across the lower 48 United States, shown as the average from 2010 to 2020 for each watershed (HUC12). The bar chart shows the proportion of each water limitation category. Water limitation levels were based on the surface water supply and use index, which expresses the imbalance between surface water-supply and consumptive use. <b>Select regions on the map</b> to view the proportions of water limitation levels for that region.</p>
              </div>
        </div>    
        <br>
        <br>
         <!-- Temporal SUI section -->
        <div class="text-container">
          <h2>When supply decreases, demand increases</h2>
          <p>Water supply shortages happen seasonally when it's hot and dry, and during drought periods when there's limited precipitation.<span v-for="reference in theseReferences.filter(item => item.refID === 'Gorski2025')" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> Due to reduced supply, water use may also increase to meet demands. For example, water use for crop irrigation peaked in 2012 in response to a year-long drought, and during summer months outdoor water use by the public is at its highest.<span v-for="reference in theseReferences.filter(item => item.refID === 'Medalie2025')" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> As a result, water limitation may be increased for local watersheds.</p>
        </div>
        <div class="chart-title-container">
            <p class="chart-title">A decade of water limitation</p>
            <p class="chart-subtitle">The proportion of the lower 48 United States in each water limitation category through time</p>
          </div>
        <div class="viz-container">
          <img class="viz-placeholder" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/01_monthly_sui_bars.png" >
        </div>
        <div class="caption-container">
          <div class="caption-text-child">
            <p>Water limitation across the lower 48 United States by month from January 2010 through January 2020. The bars show the proportion of each water limitation category as shown in the map above. Water limitation levels were based on the surface water supply and use index, which expresses the imbalance between surface water-supply and consumptive use.Each step in the chart represents one month of time. </p>
          </div>
        </div>  
        <Methods :theseReferences="referenceList"></Methods>
      <References :theseReferences="referenceList"></References>
      </div>
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>
</template>

<script setup>
import { onMounted, ref, reactive, inject, watch } from 'vue';
import * as d3 from 'd3';
import PageCarousel from '../components/PageCarousel.vue';
import RegionMap from '../components/RegionMap.vue';
import StackedBar from '../components/StackedBar.vue';
import KeyMessages from '../components/KeyMessages.vue';
import SubPages from '../components/SubPages';
import references from './../assets/text/references.js';
import References from '../components/References.vue';
import Methods from '../components/Methods.vue';
import { useRoute } from 'vue-router';
import { isMobile } from 'mobile-device-detect';
import ToggleSwitch from '../components/ToggleSwitch.vue';
import DumbellChart from '../components/DumbellChart.vue';


// dependency injections
const route = useRoute();
const featureToggles = inject('featureToggles');
const animateTime = inject('animateTime')

// References logic
// filter to this page's key message
const filteredMessages = SubPages.SubPages.filter(message => message.route === route.path);
const filteredReferences = filteredMessages[0].references;// extract list of references for this page
const theseReferences = references.key.filter((item) => filteredReferences.includes(item.refID)) 
// sort by order listed on page, reflected in list on subpages.js
const sortedReferences = theseReferences.sort((a, b) => filteredReferences.indexOf(a.refID) - filteredReferences.indexOf(b.refID))
console.log(sortedReferences)
sortedReferences.forEach((item, index) => { item.referenceNumber = `${index + 1}`; }); // add numbers
const referenceList = ref(sortedReferences);

// global vars
const mobileView = isMobile;
const publicPath = import.meta.env.BASE_URL;

// Reactive data bindings 
const data = ref([]);
const csvData = ref([]);
const selectedRegion = ref('lower 48 United States'); // default region

// props for regionMap with toggleable layers
const layers = reactive({
  very_low_none: {
    visible: true, // is it visible when loaded
    path: '01_stress_map_very_low_none.png', // file for map layer
    color: 'var(--sui-none)', // css color for layer variable
    order: 1 // order of color in stacked bar chart
  },
  low: {
    visible: true,
    path: '01_stress_map_low.png',
    color: 'var(--sui-low)',
    order: 2
  },
  moderate: {
    visible: true,
    path: '01_stress_map_moderate.png',
    color: 'var(--sui-mod)',
    order: 3
  },
  high: {
    visible: true,
    path: '01_stress_map_high.png',
    color: 'var(--sui-high)',
    order: 4
  },
  severe: {
    visible: true,
    path: '01_stress_map_severe.png',
    color: 'var(--sui-severe)',
    order: 5
  }
});

// initialize toggle states based on layer visibility
const veryLowEnabled = ref(layers.very_low_none.visible);
const lowEnabled = ref(layers.low.visible);  
const moderateEnabled = ref(layers.moderate.visible);    
const highEnabled = ref(layers.high.visible);  
const severeEnabled = ref(layers.severe.visible);    

// toggles for water supply and demand
const demandEnabled = ref(true);
const supplyEnabled = ref(true);

// data for D3 charts
const csvSUI = 'wa_stress_stats.csv' // stacked bar chart data
const csvSupplyDemand = 'wa_supply_demand.csv'

// run of show
onMounted(async () => {

  window.scrollTo(0,0);
  
  // first load the data
  data.value = await loadData(csvSupplyDemand); // supply and demand data
  csvData.value = await loadData(csvSUI);  // stacked bar chart by regions
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

// update region name stored in reactive data variable when selected on regionMap
function updateSelectedRegion(regionName) {
  selectedRegion.value = regionName;
}

// toggle layer visibility on regionMap
const toggleLayer = (layerId) => {
  layers[layerId].visible = !layers[layerId].visible;
};

</script>

<style scoped>
.content-container {
  display: block;
  margin: 0 auto;
  padding: 0px;
}
#dotplot-container{
  width: 100%;
  max-height: 900px;
}
.text-container {
  margin: 20px auto;
}
.image-container {
  position: relative;
  width: 100%; 
  max-width: 1800px;
  margin: auto; 
  overflow: hidden;
}

.background-image {
  width: 100%;
  height: 500px;
  object-fit: cover; 
  object-position: center;
  display: block;
}
.overlay-svg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}

</style>