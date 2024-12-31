<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
          <div class="text-container">
            <p>The conditions that limit water availability often occur together. For example, areas with limited water supply can be more vulnerable to water quality issues and alterations to ecological flow. The relative impact of these factors varies from region to region, and regions that have water limitation arising from more than one indicator may pose the greatest challenges to resource managers.</p>
            <br>
            <p>
            To understand water availability, USGS considers four core indicators: </p>
            <ol>
                <li>The amount of water (water quantity)</li>
                <li>The quality of surface-water</li>
                <li>The quality of groundwater</li>
                <li>Alterations to natural flow (ecoflows)</li>
              </ol>
              <br>

            <p>Within each indicator, high limitation indicates areas where water quality or quantity conditions exceed the requirements, or sensitivity, for a particular use.<span v-for="reference in theseReferences.filter(item => item.refID === 'Stets2025')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.refID }}</span></span></p>
          </div>
          <div class="text-container">
            <div class="availability-container">
              <div class="wa-map" id="sui-map">
                <h4>Water quantity</h4>
                <img class="wa-map" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/02_water_avail_wa_sui.png">
              </div>
              <div class="wa-map" id="sw-map">
                <h4>Surface water quality</h4>
                <img class="wa-map" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/02_water_avail_wa_sw_wq.png">
              </div>
              <div  id="gw-map">
                <h4>Groundwater quality</h4>
                <img class="wa-map" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/02_water_avail_wa_gw_wq.png">
              </div>
              <div id="eco-map">
                <h4>Altered natural flows</h4>
                <img class="wa-map" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/02_water_avail_wa_ecoflow.png">
              </div>
            </div>
          </div>
          <div class="caption-container">
              <div class="caption-text-child">
                <p>Maps showing the relative impact on water availability from four different categories by hydrologic region. Categories include water limitation; surface-water quality from model estimates of total nitrogen and total phosphorus (Cashman and others, in prep); groundwater quality from models of nitrate and arsenic (Ransom and others, 2022; Lombard and others, 2021); and percentage of river miles in each region with ecological flow alterations, adapted from Carlisle (2019). Darker colors indicate increasing limitation for each category.</p>
              </div>
          </div>  
          <div class="text-container">
            <h3>Water availability is limited by water quantity</h3>
            <p>The overall balance between water supply and use is a primary consideration in water availability studies. Globally, the factors affecting human water security are highly correlated; the infrastructure that allows elevated water use also promotes water-quality degradation and decreases biotic integrity. (vorosmorty xxx) Areas of the country with high water availability stress from water limitation are primarily located in the central U.S. (lin park xxx). Learn more about water balance effects on water availability in <a href="#/01Budget" target="_blank">Key Finding 1</a> and <a href="#/04Drought" target="_blank">Key Finding 4</a>. Learn more about water use effects on water availability in <a href="#/07WaterUse" target="_blank">Key Finding 7</a>, <a href="#/08WaterUseRegional" target="_blank">Key Finding 8</a>, and <a href="#/09Consumption" target="_blank">Key Finding 9</a></p>
          </div>
          <div class="text-container">
            <h3>Water availability is limited by surface water quality</h3>
            <p>Surface water quality can be degraded by nutrients, sediment, temperature, pathogens, salinity, and pesticides. Sources of water quality contaminants include agriculture, wastewater, air pollution, other human sources such as mining and land-use change, and natural sources such as springs and streamflow. Areas of the country that strongly indicate surface water quality issues include the High Plains, Souris-Red-Rainy, and the Midwest regions, largely due to the application of fertilizer and manure for agriculture. (erickson2025 xxx) Learn more about surface water quality effects on water availability in <a href="#/05WQSource" target="_blank">Key Finding 5</a> and <a href="#/06WQThreats" target="_blank">Key Finding 6</a> </p>
          </div>
          <div class="text-container">
            <h3>Water availability is limited by groundwater quality</h3>
            <p>Groundwater-derived drinking water can be affected by high concentrations of constituents from geologic sources, including arsenic, manganese, strontium, radionuclides, fluoride, and lithium, as well as salinity and nitrogen. Mixtures of multiple groundwater contaminants can also have compounding effects, because different users may have elevated sensitivity when exposed to multiple water-quality issues at once. ("Kaushal2018", "Waite2019", "Waite2021" xxx) Threats to human health, corrosion of infrastructure, reduced crop yields, poor taste, impeded navigation, and economic impacts can all result from poor water quality (erickson2025 xxx) Learn more about groundwater quality effects on water availability in <a href="#/06WQThreats" target="_blank">Key Finding 6</a> </p>
          </div>
          <div class="text-container">
            <h3>Water availability for ecosystems is limited by altered natural flows</h3>
            <p>Humans alter the natural flow of water by building water management structures, such as reservoirs, impoundments, and diversions, and by covering land with impervious surfaces. Ecological communities often rely on  local, natural flow conditions (Lennox and others, 2019; Freeman and others, 2022). Alterations to the natural flow regime therefore have the potential to limit ecological water availability. Limitations include direct stress on organisms (Bipa and others, 2024), mismatches to life-history requirements (Arthington and Balcombe, 2011; Amtstaetter and others, 2021), and changes to the functional flows necessary to create and sustain required habitats (Wharton and others, 2017; Lennox and others, 2019; Hitt and others, 2020; Comte and others, 2021; Kemp and Kemp, 2023; Cashman and others, in prep.). </p>
          </div>
          <Methods></Methods>
          <References :theseReferences="referenceList"></References>
        </div>
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>
</template>

<script setup>
import {inject, ref} from 'vue';
import { useRoute } from 'vue-router';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import references from './../assets/text/references.js';
import References from '../components/References.vue';
import SubPages from '../components/SubPages';
import { isMobile } from 'mobile-device-detect';

const route = useRoute();
const featureToggles = inject('featureToggles');


//////// references array //
// filter to this page's key message
const filteredMessages = SubPages.SubPages.filter(message => message.route === route.path);

// extract list of references for this page
const filteredReferences = filteredMessages[0].references;

// Sort references
const refArray = references.key.sort((a, b) => a.authors.localeCompare(b.authors));

// extract references that match the refID from global list
const theseReferences = refArray.filter((item) => filteredReferences.includes(item.refID))

// add numbers
theseReferences.forEach((item, index) => {
  item.referenceNumber = `${index + 1}`;
});

const referenceList = ref(theseReferences);

/////////

</script>

<style scoped>
.availability-container {
  display: grid;
  width: 100%;
  grid-template-columns: 1fr 1fr;
  grid-template-rows: auto auto;
}
.wa-map {
  max-height: 200px;
  padding-bottom: 15px;
}

@media only screen and (max-width: 768px) {
  .availability-container {
  display: grid;
  width: 100%;
  grid-template-columns: 1fr;
  grid-template-rows: auto auto auto auto;
}
}

</style>