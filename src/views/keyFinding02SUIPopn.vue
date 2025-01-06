<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
          <div class="chart-title-container">
            <h3>Where is water availability limited, and why?</h3>

          </div>
          <div class="text-container">
            <p>The conditions that limit water availability often occur together, including water quantity, quality, and natural flows. For example, areas with limited water supply can be more vulnerable to water quality issues and flow alterations. These maps show four conditions that affect water availability, and the darker the region is, the more that area's water availability is limited.</p>
          </div>
          <div class="text-container">

            <div class="availability-container">
              <div class="wa-map-text-container" id="sui-map">
                <h4 class="wa-title">Water quantity</h4>
                <p class="wa-text">Limitations from water quantity are related to the balance between water supply and demand. Areas of the country with high water quantity limitation are primarily located in the central U.S. and Mississippi Embayment. Learn more about water limitation in <a href="#/01-water-limitation" target="_blank">Key Finding 1</a>, <a href="#/03-vulnerability" target="_blank">Key Finding 3</a>, and <a href="#/04-water-supply" target="_blank">Key Finding 4</a>. Learn more about water use effects on water availability in <a href="#/07-water-use" target="_blank">Key Finding 7</a> and <a href="#/08-regional-wu" target="_blank">Key Finding 8</a>. </p>
                <img class="wa-map" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/02_water_avail_wa_sui.png">
              </div>
              <div class="wa-map-text-container" id="sw-map">
                <h4 class="wa-title">Surface water quality</h4>
                <img class="wa-map" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/02_water_avail_wa_sw_wq.png">
                <p class="wa-text">Surface water quality can be degraded by nutrients, sediment, temperature, pathogens, salinity, and pesticides. Areas of the country that face surface water quality issues include the central and midwest U.S., largely due to the application of fertilizer and manure for agriculture. (erickson2025 xxx). Learn more about surface water quality effects on water availability in <a href="#/05-nutrients" target="_blank">Key Finding 5</a> and <a href="#/06-water-quality" target="_blank">Key Finding 6</a>.</p>
              </div>
              <div class="wa-map-text-container" id="gw-map">
                <h4 class="wa-title">Groundwater quality</h4>
                <img class="wa-map" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/02_water_avail_wa_gw_wq.png">
                <p class="wa-text">Groundwater-derived drinking water can be affected by high concentrations of constituents from geologic sources, including arsenic, manganese, strontium, radionuclides, fluoride, and lithium, as well as salinity and nitrogen. Areas of the country with challenges to maintaining groundwater quality include the central and southwestern U.S. Learn more about groundwater quality and water availability in <a href="#/06-water-quality" target="_blank">Key Finding 6</a>.</p>
              </div>
              <div class="wa-map-text-container" id="eco-map">
                <h4 class="wa-title">Altered natural flows</h4>
                <img class="wa-map" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/02_water_avail_wa_ecoflow.png">
                <p class="wa-text">Humans alter the natural flow of water by building water management structures, such as reservoirs, impoundments, and diversions, and by covering land with impervious surfaces. Ecological communities often rely on  local, natural flow conditions (Lennox and others, 2019; Freeman and others, 2022). Altered flows primarily limit water availability in the Northeast, Florida, Texas, and Central High Plains regions.</p>
              </div>
            </div>
          </div>
          
          <div class="text-container">
            <h3>What about in the future?</h3>
            <p>The continuing rise in global temperature as a result of human activity is causing changes in Earth's water cycle. The amount of water stored within and moving between vapor, liquid and frozen components of the water cycle is shifting, with significant consequences for water availability. </p>
            <ul class="tab-content-list">
                    <li>Temperature is rising, with amplified drought events, increased evaporative water loss, increased groundwater demand, and changes in streamflow amount and timing.</li>
                    <li>Snow and ice are diminishing, including reduced snow cover extent and duration, decreased glaciers and increasing meltwater, thawing permafrost, erosion and turbidity from increased melt rates, and altered rain and snow patterns.</li>
                    <li>Sea levels are rising, exacerbating the impacts of stronger hurricanes, infrastructure damage, and increased storm surges and coastal flooding.</li>
                    <li>There will be additional impacts, including increased sediment from extreme rainfall, wildfires, more frequent sand and dust storms, and increased salinity from evaporation of surface waters and saltwater intrusion in coastal aquifers.</li>
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
const refArray = references.key.sort((a, b) => a.authors.localeCompare(b.authors)); // Sort references
const theseReferences = refArray.filter((item) => filteredReferences.includes(item.refID)) // extract references that match the refID from global list
theseReferences.forEach((item, index) => { item.referenceNumber = `${index + 1}`; }); // add numbers
const referenceList = ref(theseReferences);

</script>

<style scoped>
.availability-container {
  display: grid;
  width: 100%;
  grid-template-columns: 1fr;
  grid-template-rows: auto auto auto auto;
}
.wa-map-text-container {
  display: grid;
  width: 100%;
  grid-template-columns: 1fr 2fr;
  grid-template:
    "title title"
    "map text"
}
.wa-title {
  grid-area: title;
}
.wa-text {
  grid-area: text;
}
.wa-map {
  grid-area: map;
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