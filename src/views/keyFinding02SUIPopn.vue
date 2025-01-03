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
          <div class="chart-title-container">
            <p class="chart-title">Impacts on water availability</p>
            <p class="chart-subtitle">Darker colors indicate were aspects of water availability are more limited</p>
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
                <p>Maps showing the relative impacts on water availability from water quantity, quality, and altered flows for each hydrologic region in the lower 48 United States (cite van meter) (cite budget chapter). Darker colors in each map indicate regions with higher impacts on water availability from that component.</p>
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
          <div class="text-container">
            <h3>Future water availability</h3>
            <p>The steady rise in global temperature as a result of human activity is causing changes in Earth's water cycle. The amount of water stored within and moving between vapor, liquid and frozen components of the water cycle is shifting, with significant consequences for water availability. Examples of potential threats to the quantity and quality of water available for humans and ecosystems in North America include increases in drought, aridification, and fire weather; heavy precipitation and flooding; cryosphere decline; rising surface-water temperatures; and saltwater intrusion in coastal areas. [cite IPCC, Ranasinghe and others (2021) , and Scholl 2025]</p>
            <h4>Potential future impacts to water quantity</h4>
            <ul class="tab-content-list">
                    <li>Temperature impacts, including amplified drought events, increased evaporative water loss, increased groundwater demand, and changes in streamflow amount and timing</li>
                    <li>Snow and ice impacts, including reduced snow cover extent and duration, decreased glaciers and increasing meltwater, thawing permafrost, and altered rain and snow patterns</li>
                    <li>Other impacts, including stronger hurricanes, rising sea levels, and increased storm surges and coastal flooding</li>
                  </ul>
                <h4>Potential future impacts to water quality</h4>
                  <ul class="tab-content-list">
                    <li>Temperature impacts, including temperature pollution, amplified drought events, and increased groundwater demand</li>
                    <li>Snow and ice impacts, including thawing permafrost, decreased glaciers and increasing meltwater, warmer and shorter winter seasons</li>
                    <li>Other impacts, including increased erosion, increased sand and dust storms, increased saltwater intrusion, and impacts to agriculture</li>
                  </ul>
                <h4>Potential future impacts to natural flows</h4>
                  <ul class="tab-content-list">
                    <li>Temperature impacts, including amplified drought events, increased groundwater demand, decreased cold-water fish populations and habitat, and changes in streamflow amount and timing</li>
                    <li>Snow and ice impacts, changes in snowmelt timing and amount, decreased lake and river ice extent, reduced snow cover extent and duration, and thawing permafrost</li>
                    <li>Other impacts, including stronger hurricanes, stronger severe wind storms, increased erosion, increased storm surge and coastal flooding, and increased saltwater intrusion</li>
                  </ul>
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

const route = useRoute();
const featureToggles = inject('featureToggles');

// References logic
// filter to this page's key message
const filteredMessages = SubPages.SubPages.filter(message => message.route === route.path);
const filteredReferences = filteredMessages[0].references;// extract list of references for this page
const theseReferences = references.key.filter((item) => filteredReferences.includes(item.refID)) 
// sort by order listed on page, reflected in list on subpages.js
const sortedReferences = theseReferences.sort((a, b) => filteredReferences.indexOf(a.refID) - filteredReferences.indexOf(b.refID))
sortedReferences.forEach((item, index) => { item.referenceNumber = `${index + 1}`; }); // add numbers
const referenceList = ref(sortedReferences);

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