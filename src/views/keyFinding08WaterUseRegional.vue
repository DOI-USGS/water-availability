<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
          <div class="text-container">
                <p>How we use water varies across the country, including the type of use (for example, crop irrigation, public supply, and thermoelectric power) and the source of water (groundwater versus surface water). Crop irrigation is the largest category of use in the western U.S., while thermoelectric power is the largest category of use in the eastern U.S. Public supply accounts for nearly one-half of water withdrawals in some urban areas, and withdrawals for public supply are largest in states with large populations, such as California, Texas, New York, and Florida. </p>
          </div>
          <div class="viz-container">
          <HorizontalBar 
            categoricalVariable="d3_category"
            continuousRaw="total_use"
            continuousPercent="d3_percentage"
            :layerPaths="{
              ir_total: { path: layers.ir_total.path, color: layers.ir_total.color, order: layers.ir_total.order, label: layers.ir_total.label },
              ps_total: { path: layers.ps_total.path, color: layers.ps_total.color, order: layers.ps_total.order, label: layers.ps_total.label },
              te_total: { path: layers.te_total.path, color: layers.te_total.color, order: layers.te_total.order, label: layers.te_total.label },
              te_saline: { path: layers.te_saline.path, color: layers.te_saline.color, order: layers.te_saline.order, label: layers.te_saline.label },
            }"
            :data="csvData"
            :regionName="selectedRegion"
          
          />
          </div>
          <div class="viz-container">
          <RegionMap 
          @regionSelected="updateSelectedRegion"
          :layerVisibility="{
            ir_total: layers.ir_total.visible,
            ps_total: layers.ps_total.visible,
            te_total: layers.te_total.visible,
            te_saline: layers.te_saline.visible,
          }"
          :layerPaths="{
            ir_total: { path: layers.ir_total.path, color: layers.ir_total.color, order: layers.ir_total.order },
            ps_total: { path: layers.ps_total.path, color: layers.ps_total.color, order: layers.ps_total.order },
            te_total: { path: layers.te_total.path, color: layers.te_total.color, order: layers.te_total.order },
            te_saline: { path: layers.te_saline.path, color: layers.te_saline.color, order: layers.te_saline.order },
          }"
          regionsDataUrl="assets/Regions.topojson"
          usOutlineUrl="assets/USoutline.topojson"
          regionsVar="Region_nam_nospace"
          layerMag="1.2"
          layerX="-80"
          layerY="-55"

        />
        </div>
        <div class="caption-container">
              <div class="caption-legend-child">
                <div class="checkbox_item" id="checkbox-ir" >
                  <label class="checkbox_wrap">
                  <input type="checkbox" 
                  name="checkbox" 
                  class="checkbox_inp" 
                  @click="toggleCategory('ir_total')">
                  <span class="checkbox_mark"></span>
                    Crop irrigation
                  </label>
                </div>
                <div class="checkbox_item" id="checkbox-ps" >
                  <label class="checkbox_wrap">
                  <input type="checkbox" 
                  name="checkbox" 
                  class="checkbox_inp" 
                  @click="toggleCategory('ps_total')">
                  <span class="checkbox_mark"></span>
                    Public supply
                  </label>
                </div>
                <div class="checkbox_item" id="checkbox-te-fresh" >
                  <label class="checkbox_wrap">
                  <input type="checkbox" 
                  name="checkbox" 
                  class="checkbox_inp" 
                  @click="toggleCategory('te_total')">
                  <span class="checkbox_mark"></span>
                    Thermoelectric (fresh)
                  </label>
                </div>
                <div class="checkbox_item" id="checkbox-te-saline" >
                  <label class="checkbox_wrap">
                  <input type="checkbox" 
                  name="checkbox" 
                  class="checkbox_inp" 
                  @click="toggleCategory('te_saline')">
                  <span class="checkbox_mark"></span>
                    Thermoelectric (saline)
                  </label>
                </div>
              </div>
              <div class="caption-text-child">
                <p>Map of modeled water use for the top four water use categories at the HUC12 level. Crop irrigation and public supply are shaded by the proportion of use for each watershed. Thermoelectric is represented by points in the watersheds where thermoelectric water withdrawals occur, with point size scaled to total withdrawal size. The bar chart shows the total daily water use for that category for the selected region. </p>
              </div>
          </div> 
          <div class="text-container">
            <h3>Water from above and below</h3>
            <p>Across the U.S., the source of water, whether from  groundwater or from surface water typically depends on the availability of these sources and on the category of use. On average during water years 2010-2020, about 62% of water withdrawals for the combination of public supply, crop irrigation, and thermoelectric power across the country were from surface water and 38% of withdrawals were from groundwater. However, these proportions vary widely across the country, and are affected by water use type as well as local and federal water use ordinances and water rights.</p>
          </div>
          <div class="chart-title-container">
            <p class="chart-title">Source of public supply water in the {{ regionTitle }}</p>
            <p class="chart-subtitle">Daily water use (million gallons per day) sourced from surface water versus groundwater</p>
          </div>
          <div class="viz-container">
            <Reg class="dumbbell-reg-svg" id="svg-style"></Reg>
            <img
                class="viz-half"
                id="dumbbells"
                :src="imgSrc"
                alt=""
            >    
          </div>
          <div class="caption-container">

              <div class="caption-legend-child">
                <div class="legend_item" id="legend-wu-sw" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                    Surface water
                  </label>
                </div>
                <div class="legend_item" id="legend-wu-gw" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                    Groundwater
                  </label>
                </div>
              </div>
              <div class="caption-text-child">
                <p>Bar charts showing the relative amount of modeled water withdrawn for public supply that comes from surface water (bars that go up) or from groundwater (bars that go down) for the lower 48 United States (cite van meter). The bars are placed from west to east based on the longitude (easting) of the center of each watershed. The watershed with the largest daily water use in that region are labeled for each source. Select a region on the map to view bar charts for that region.</p>
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
import { ref, onMounted, inject, reactive } from 'vue';
import { useRoute } from 'vue-router';
import * as d3 from 'd3';
import Reg from "../../public/assets/Regions.svg";
import PageCarousel from '../components/PageCarousel.vue';
import Methods from '../components/Methods.vue';
import KeyMessages from '../components/KeyMessages.vue';
import references from './../assets/text/references.js';
import References from '../components/References.vue';
import SubPages from '../components/SubPages';
import RegionMap from '../components/RegionMap.vue';
import HorizontalBar from '../components/HorizontalBar.vue';

// global variables
const publicPath = import.meta.env.BASE_URL;
const baseURL = "https://labs.waterdata.usgs.gov/visualizations/images/water-availability/";
const defaultRegionID = "CONUS";
const imgSrc = ref(getImgURL(defaultRegionID));
const featureToggles = inject('featureToggles');
const focalFill = "var(--focal-fill)";
const defaultFill = "var(--inactive-grey)";
const csvData = ref([]);
const selectedRegion = ref('lower 48 United States'); // default region
let regionTitle = "lower 48 United States"

const route = useRoute();

// References logic
// filter to this page's key message
const filteredMessages = SubPages.SubPages.filter(message => message.route === route.path);
const filteredReferences = filteredMessages[0].references;// extract list of references for this page
const refArray = references.key.sort((a, b) => a.authors.localeCompare(b.authors)); // Sort references
const theseReferences = refArray.filter((item) => filteredReferences.includes(item.refID)) // extract references that match the refID from global list
theseReferences.forEach((item, index) => { item.referenceNumber = `${index + 1}`; }); // add numbers
const referenceList = ref(theseReferences);

// toggle maps on and off
const layers = reactive({
  ir_total: {
    visible: true,
    path: '08_wu_ir_map.png',
    color: 'var(--wu-agriculture)',
    order: 1,
    label: "Irrigation"
  },
  ps_total: {
    visible: true,
    path: '08_wu_ps_map.png',
    color: 'var(--wu-ps)',
    order: 2,
    label: "Public supply"
  },
  te_total: {
    visible: true,
    path: '08_wu_te_fresh_map.png',
    color: 'var(--wu-te-fresh)',
    order: 3,
    label: "Thermoelectric fresh"
  },
  te_saline: {
    visible: true,
    path: '08_wu_te_saline_map.png',
    color: 'var(--wu-te-saline)',
    order: 4,
    label: "Thermoelectric saline"
  },
});

// water use data for regions
const csvWU = "wu_regions.csv"

function updateSelectedRegion(regionName) {
  selectedRegion.value = regionName;
}

// functions called here
onMounted(async() => {
  try {
    const data = await d3.csv(`${publicPath}${csvWU}`);
    csvData.value = data;
  addInteractions();

  // select default region to start
  d3.select('.dumbbell-reg-svg').selectAll(`#${defaultRegionID}`).style("fill", focalFill);
  } catch (error) {
    console.error("Error loading CSV data:", error);
  }
});

function toggleCategory(category) {
  layers[category].visible = !layers[category].visible;
  addClassToImage(category);
}

function addClassToImage(category) {
	var useImage = document.getElementById(category);
  var useButton = document.getElementById(category + "Button");
  if(useImage) {
  	if(useImage.classList.contains('visible')) {
      useImage.classList.remove('visible');
      useImage.classList.add('hidden');
      useButton.classList.add('active');
      useButton.classList.remove('inactive-toggle');
    }
    else {
  		useImage.classList.add('visible');
      useImage.classList.remove('hidden');
      useButton.classList.add('inactive-toggle');
      useButton.classList.remove('active');
    }
  }
}

function getImgURL(id) {
  return new URL(`${baseURL}08_PS_gw_sw_dumbbell_${id}.png`);
}


function addInteractions() {
  const mapSVG = d3.select('.dumbbell-reg-svg');
  mapSVG.selectAll('.Region_nam_nospace')
    .on("mouseover", mouseoverMap)
    .on("mouseout", mouseoutMap);
};

function mouseoverMap(event) {
  const regionID = event.target.id;
  d3.select('.dumbbell-reg-svg').selectAll(`#${defaultRegionID}`).style("fill", defaultFill);
  d3.select('.dumbbell-reg-svg').selectAll(`#${regionID}`).style("fill", focalFill);
  imgSrc.value = getImgURL(regionID);
  regionTitle = regionID.replaceAll("_", " ") + " Region"; // default region
};

function mouseoutMap(event) {
  const regionID = event.target.id;
  d3.select('.dumbbell-reg-svg').selectAll(`#${regionID}`).style("fill", defaultFill);
  d3.select('.dumbbell-reg-svg').selectAll(`#${defaultRegionID}`).style("fill", focalFill);
  imgSrc.value = getImgURL(defaultRegionID);
  regionTitle = "lower 48 United States";
};

</script>


<style scoped>

</style>