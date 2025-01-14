<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
          <div class="text-container">
            <h2>Where is water availability limited, and why?</h2>
            <p>The conditions that impact water availability often occur together, including water quantity, quality, and natural flows.<span v-for="reference in theseReferences.filter(item => item.refID === 'Stets2025')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> For example, areas with limited water supply can be more vulnerable to water quality issues or flow alterations. These maps show four conditions that affect water availability. The darker regions indicate more severe impacts from that particular aspect of water availability.</p>
          </div>
          <div class="text-container">

            <div class="availability-container">
              <div class="wa-map-text-container" id="sui-map">
                <h3 class="wa-title">Water quantity</h3>
                <p class="wa-text">Impacts to water availability from water quantity are related to the balance between water supply and demand.<span v-for="reference in theseReferences.filter(item => item.refID === 'Stets2025')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> Areas of the country with high water quantity limitation are primarily located in the central U.S. and Mississippi Embayment. Learn more about water limitation (<a href="#/01-water-limitation" target="_blank">link</a>) and water supply at a national level (<a href="#/04-water-supply" target="_blank">link</a>), and how they relate to social vulnerability (<a href="#/03-vulnerability" target="_blank">link</a>). Learn more about water use effects on water availability at a national scale (<a href="#/07-water-use" target="_blank">link</a>) and regionally (<a href="#/08-regional-wu" target="_blank">link</a>). </p>
                <img class="wa-map" :src="`${s3ProdURL}images/water-availability/02_water_avail_wa_sui.png`">
              </div>
              <div class="wa-map-text-container" id="sw-map">
                <h3 class="wa-title">Surface water quality</h3>
                <img class="wa-map" :src="`${s3ProdURL}images/water-availability/02_water_avail_wa_sw_wq.png`">
                <p class="wa-text">Surface water quality can be degraded by nutrients, sediment, temperature, pathogens, salinity, or pesticides.<span v-for="reference in theseReferences.filter(item => item.refID === 'Erickson2025')" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> The central and midwest U.S., have the most widespread water quality issues due to the application of fertilizer and manure for agriculture. Learn more about surface water quality effects on water availability from excess nutrients (<a href="#/05-nutrients" target="_blank">link</a>) and other human-health contaminants (<a href="#/06-water-quality" target="_blank">link</a>).</p>
              </div>
              <div class="wa-map-text-container" id="gw-map">
                <h3 class="wa-title">Groundwater quality</h3>
                <img class="wa-map" :src="`${s3ProdURL}images/water-availability/02_water_avail_wa_gw_wq.png`">
                <p class="wa-text">Groundwater can be affected by high concentrations of contaminants from geologic sources, including arsenic, manganese, strontium, radionuclides, fluoride, or lithium, as well as salinity and nitrogen.<span v-for="reference in theseReferences.filter(item => item.refID === 'Erickson2025')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> Areas of the country with challenges to groundwater quality include the central and southwestern U.S. Learn more about groundwater quality effects on water availability from excess geologic contaminants (<a href="#/06-water-quality" target="_blank">link</a>).</p>
              </div>
              <div class="wa-map-text-container" id="eco-map">
                <h3 class="wa-title">Altered natural flows</h3>
                <img class="wa-map" :src="`${s3ProdURL}images/water-availability/02_water_avail_wa_ecoflow.png`">
                <p class="wa-text">Humans alter the natural flow of water by building water management structures, such as reservoirs, impoundments, and diversions, and by covering land with impervious surfaces.<span v-for="reference in theseReferences.filter(item => item.refID === 'Stets2025')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> Altered flows primarily limit water availability in the Northeast, Florida, Texas, and Central High Plains regions.</p>
              </div>
            </div>
          </div>
          <div class="caption-container">
              <div class="caption-text-child">
                <p> </p>
              </div>
            </div> 
            <div class="caption-container-flex caption-container">
              <div class="legend-group">
                <ColorLegend legend-id="legend-wa-none" label="Very low impact" color="var(--wa-none)" />
                <ColorLegend legend-id="legend-wa-low" label="Low impact" color="var(--wa-low)" />
                <ColorLegend legend-id="legend-wa-mod" label="Moderate impact" color="var(--wa-mod)" />
                <ColorLegend legend-id="legend-wa-high" label="High impact" color="var(--wa-high)" />
                <ColorLegend legend-id="legend-wa-severe" label="Severe impact" color="var(--wa-severe)" />
                        </div>
              <div class="caption-text-flex caption-text-child">
                <p>Maps showing the severity of impacts from water quantity, quality, and altered flows on water availability for each hydrologic region in the lower 48 United States.<span v-for="reference in theseReferences.filter(item => item.refID === 'VanMetre2020')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> Darker colors indicate more severe impacts to water availability.</p>
              </div>
            </div> 
          
          <div class="text-container">
            <h2>What about in the future?</h2>
            <p>The continuing rise in global temperature as a result of human activity is causing changes in Earth's water cycle, with significant consequences for water availability.<span v-for="reference in theseReferences.filter(item => item.refID === 'Scholl2025')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> </p>
            <ul class="tab-content-list">
                    <li><b>Temperature is rising</b>, with amplified drought events, increased evaporative water loss, increased groundwater demand, and changes in streamflow amount and timing.</li>
                    <li><b>Snow and ice are diminishing</b>, including reduced snow cover extent and duration, decreased glaciers and increased meltwater, thawing permafrost, erosion and turbidity from increased melt rates, and altered rain and snow patterns.</li>
                    <li><b>Sea levels are rising</b>, exacerbating the impacts of stronger hurricanes, infrastructure damage, and increased storm surges and coastal flooding.</li>
                    <li><b>There will be additional impacts</b>, including increased sediment from extreme rainfall, wildfires, more frequent sand and dust storms, and increased salinity from evaporation of surface waters and saltwater intrusion in coastal aquifers.</li>
                  </ul>
                
          </div>
          <Methods :theseReferences="referenceList"></Methods>
          <References :theseReferences="referenceList"></References>
        </div>
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>
</template>

<script setup>
import {inject, ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/MethodsSection.vue';
import references from './../assets/text/references.js';
import References from '../components/ReferencesSection.vue';
import SubPages from '../components/SubPages';
import ColorLegend from '../components/ColorLegend.vue';



const route = useRoute();
const featureToggles = inject('featureToggles');

// S3 resource sourcing
const s3ProdURL = import.meta.env.VITE_APP_S3_PROD_URL;

// References logic
// filter to this page's key message
const filteredMessages = SubPages.SubPages.filter(message => message.route === route.path);
const filteredReferences = filteredMessages[0].references;// extract list of references for this page
const theseReferences = references.key.filter((item) => filteredReferences.includes(item.refID)) 
// sort by order listed on page, reflected in list on subpages.js
const sortedReferences = theseReferences.sort((a, b) => filteredReferences.indexOf(a.refID) - filteredReferences.indexOf(b.refID))
sortedReferences.forEach((item, index) => { item.referenceNumber = `${index + 1}`; }); // add numbers
const referenceList = ref(sortedReferences);


onMounted(() => {
  window.scrollTo(0, 0)
})
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

@media only screen and (max-width: 600px) {
  .availability-container {
    display: grid;
    width: 100%;
    grid-template-columns: 1fr;
    grid-template-rows: auto auto auto auto;
  }
  .wa-map-text-container {
  display: grid;
  width: 100%;
  grid-template-columns: 1fr;
  grid-template:
    "title"
    "map"
    "text"
}
}

</style>