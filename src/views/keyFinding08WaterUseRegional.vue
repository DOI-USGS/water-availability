<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
          <div class="text-container">
                <p>How we use water varies widely across the country, from the type of use (for example, crop irrigation, public supply, and thermoelectric power) to the source of water (groundwater versus surface water).<span v-for="reference in theseReferences.filter(item => item.refID === 'Medalie2025')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> Crop irrigation is the largest category of use in the western U.S., while thermoelectric power is the largest category of use in the eastern U.S. Public supply accounts for nearly one-half of water withdrawals in some urban areas, and withdrawals for public supply are largest in states with large populations, such as California, Texas, New York, and Florida. </p>
          </div>
          <div class="chart-title-container">
            <p class="chart-title">Water use in the {{ selectedRegion === 'lower 48 United States' ? selectedRegion : `${selectedRegion} Region`}}</p>
            <p class="chart-subtitle">Daily water use in 2020, in million gallons per day</p>
          </div>
          <div class="image-container">
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
          <RegionMap 
          class="region-map"
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
        <div class="caption-container-flex caption-container">
          <div class="toggle-group">
            <b>Toggle map layers:</b> 
              <ToggleSwitch 
                v-model="layers.ir_total.visible" 
                :label="layers.ir_total.label"
                :rightColor="layers.ir_total.color"
              />

              <ToggleSwitch 
                v-model="layers.ps_total.visible" 
                :label="layers.ps_total.label"
                :rightColor="layers.ps_total.color"
              />

              <ToggleSwitch 
                v-model="layers.te_total.visible" 
                :label="layers.te_total.label"
                :rightColor="layers.te_total.color"
              />

              <ToggleSwitch 
                v-model="layers.te_saline.visible" 
                :label="layers.te_saline.label"
                :rightColor="layers.te_saline.color"
              />
              </div>
              <div class="caption-text-flex caption-text-child">
                <p>Map showing the distribution of modeled water use by category for each watershed (HUC12) in the lower 48 United States. Crop irrigation and public supply are shaded by daily withdrawal for each watershed. The thermoelectric points are scaled to represent daily withdrawals for each watershed where thermoelectric water withdrawal occurs. The bar graph shows the total daily water use for the selected region.<span v-for="reference in theseReferences.filter(item => item.refID === 'VanMetre2020')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span></p>
              </div>

          </div> 
          <br>
          <br>
          <div class="text-container">
            <h2>Do we use more surface water or groundwater?</h2>
            <p>Across the U.S., this depends on the availability of each source, the category of use, local and federal water use ordinances, and water rights. On average during water years 2010-2020, about 62% of water used for crop irrigation, public supply, and thermoelectric was sourced from surface water rather than groundwater. However, these proportions vary widely across the country: the largest water withdrawals in the Southwest Desert region for public supply are from groundwater, whereas the largest withdrawals in the Northeast region are from surface water.</p>
          </div>
          <div class="chart-title-container">
            <p class="chart-title">Source of public supply water in the {{ regionTitle }}</p>
            <p class="chart-subtitle">Daily water use (million gallons per day) sourced from surface water versus groundwater</p>
          </div>
          <div class="viz-container">
            <Reg class="dumbbell-reg-svg reg-svg" id="svg-style"></Reg>
            <img
                class="viz-half"
                id="dumbbells"
                :src="imgSrc"
                alt=""
            >    
          </div>
          <div class="caption-container-flex caption-container">
              <div class="legend-group">
                <ColorLegend legend-id="legend-wu-sw" label="Surface water" color="var(--wu-sw)" />
                <ColorLegend legend-id="legend-wu-gw" label="Groundwater" color="var(--wu-gw)" />
              </div> 
              <div class="caption-text-flex caption-text-child">
                <p>Bar charts showing the relative amount of modeled water withdrawn for public supply that comes from surface water (bars that go up) or from groundwater (bars that go down) for the lower 48 United States.<span v-for="reference in theseReferences.filter(item => item.refID === 'VanMetre2020')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> The bars are placed from west to east based on the longitude (easting) of the center of each watershed. The watershed with the largest daily water use in that region are labeled for each source. Select a region on the map to view bar charts for that region.</p>
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
import ToggleSwitch from '../components/ToggleSwitch.vue';
import ColorLegend from '../components/ColorLegend.vue';


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
const theseReferences = references.key.filter((item) => filteredReferences.includes(item.refID)) 
// sort by order listed on page, reflected in list on subpages.js
const sortedReferences = theseReferences.sort((a, b) => filteredReferences.indexOf(a.refID) - filteredReferences.indexOf(b.refID))
sortedReferences.forEach((item, index) => { item.referenceNumber = `${index + 1}`; }); // add numbers
const referenceList = ref(sortedReferences);

// toggle maps on and off
const layers = reactive({
  ir_total: {
    visible: true,
    path: '08_wu_ir_map.png',
    color: 'var(--wu-agriculture)',
    order: 1,
    label: "Crop irrigation"
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

  window.scrollTo(0, 0);

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