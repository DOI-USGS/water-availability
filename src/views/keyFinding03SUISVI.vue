<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
              <p>About 26.7 million people, or 8% of the population, live in areas of high or severe water limitation.<span v-for="reference in theseReferences.filter(item => item.refID === 'Stets2025')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> The availability of clean water for our communities is affected by factors like water quantity, quality, and flow, as well as social factors like water infrastructure, access, and rights. Socioeconomic status, access to resources, and the availability of public services can determine a community's adaptive capacity. The adaptive capacity ultimately affects how vulnerable or resilient a community may be when faced with water-availability limitations.</p>
            </div>

            <div class="chart-title-container">
              <p class="chart-title">How does social vulnerability relate to water limitation?</p>
              <p class="chart-subtitle">Map shows each hydrologic unit (HUC8) scaled by social vulnerability score and colored by water limitation category.</p>
            </div>
            <div class="viz-container">
              <img class="viz-landscape" :src="`${s3ProdURL}images/water-availability/03_sui_popn_CONUS.png`">
            </div>
            <div class="caption-container-flex caption-container">
              <div class="legend-group">
                <b>Water limitation:</b>
                <ColorLegend legend-id="legend-sui-none" label="Very low (0 - 0.2)" color="var(--sui-none)" />
                <ColorLegend legend-id="legend-sui-low" label="Low (0.2 - 0.4)" color="var(--sui-low)" />
                <ColorLegend legend-id="legend-sui-mod" label="Moderate (0.4 - 0.6)" color="var(--sui-mod)" />
                <ColorLegend legend-id="legend-sui-high" label="High (0.6 - 0.8)" color="var(--sui-high)" />
                <ColorLegend legend-id="legend-sui-severe" label="Severe (0.8 - 1.0)" color="var(--sui-severe)" />
                        </div>
              <div class="caption-text-flex caption-text-child">
                <p>Map showing circles for each hydrologic unit (HUC8). The color of the circle is the level of water limitation. Water limitation levels were based on the surface water supply and use index, which expresses the imbalance between surface water-supply and consumptive use. The size of the bubble represents the social vulnerability score, with larger bubbles representing more social vulnerability.<span v-for="reference in theseReferences.filter(item => item.refID === 'CDC2022')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span></p>
              </div>
            </div> 
            <div class="text-container">
                <h2>Water insecurity</h2>
                <p>Despite tremendous gains throughout the 20th century, limitations to water access and quality persist in the United States. These limitations disproportionately affect <a href="https://labs.waterdata.usgs.gov/visualizations/vulnerability-indicators/index.html#/en" target="_blank">socially vulnerable</a> communities. Societal factors shape exposure to hazards, susceptibility to suffer harm, and ability to cope and recover from losses.<span v-for="reference in theseReferences.filter(item => item.refID === 'Drakes2024')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> </p>
            </div>
            <div class="chart-title-container">
              <p class="chart-title">Social vulnerability and water limitation</p>
              <p class="chart-subtitle">Bars show the proportion of the population living in varying levels of water limitation for each social vulnerability classification.</p>
            </div>
            <div class="svi-bar-container">
              <div class="svi-bar-child">
                <p class="chart-text svi-text">Severe social vulnerability </p>
                <img class="svi-image" :src="`${s3ProdURL}images/water-availability/03_svi_bar_Severe.png`">
              </div>
              <div class="svi-bar-child">
                <p class="chart-text svi-text">High social vulnerability </p>
                <img class="svi-image" :src="`${s3ProdURL}images/water-availability/03_svi_bar_High.png`">
              </div>
              <div class="svi-bar-child">
                <p class="chart-text svi-text">Moderate social vulnerability </p>
                <img class="svi-image" :src="`${s3ProdURL}images/water-availability/03_svi_bar_Moderate.png`">
              </div>
              <div class="svi-bar-child">
                <p class="chart-text svi-text">Low social vulnerability </p>
                <img class="svi-image" :src="`${s3ProdURL}images/water-availability/03_svi_bar_Low.png`">
              </div>
              
            </div>
            <div class="caption-container">
              <div class="caption-text-child">
                <p>Bar charts showing the proportion of the population<span v-for="reference in theseReferences.filter(item => item.refID === 'Census2020')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> of the lower 48 United States living in varying categories of social vulnerability. The color represents the level of water limitation as shown in the map above. Water limitation levels were based on the surface water supply and use index, which expresses the imbalance between surface water-supply and consumptive use. </p>
              </div>
            </div> 
            <div class="text-container">
                <h2>Access to clean water</h2>
                <p>Exposure to drinking-water contamination occurs at higher rates for low-income communities, minority-dominated communities, and those who depend on domestic wells as their drinking water source, compared to communities who are not socially vulnerable.<span v-for="reference in theseReferences.filter(item => item.refID === 'Erickson2025')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.label }}</span></span> While nitrogen and phosphorus pollution are problems for most communities in the U.S., watersheds with the highest levels of nitrogen and phosphorus contamination contain relatively higher proportions of socially vulnerable individuals. </p>
            </div>
        <Methods :theseReferences="referenceList"></Methods>
        <References :theseReferences="referenceList"></References>
        </div>
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>
</template>

<script setup>
import { inject, ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/MethodsSection.vue';
import references from './../assets/text/references.js';
import References from '../components/ReferencesSection.vue';
import SubPages from '../components/SubPages';
import ColorLegend from '../components/ColorLegend.vue';

// S3 resource sourcing
const s3ProdURL = import.meta.env.VITE_APP_S3_PROD_URL;

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

onMounted(() => {
  window.scrollTo(0, 0)
})

</script>

<style scoped>

.svi-bar-container {
  width: 65%;
  min-width: 600px;
  max-width: 1800px;
  margin: 0 auto;
  padding-bottom: 10px;
  display: grid;
  grid-template-columns: 1fr;
}
.svi-bar-child {
  align-items: center;
  display: grid;
  grid-template-columns: 250px auto;
  justify-items: right;
  margin: 0px;
}
.svi-image {
  max-width: 600px;
  width: 100%;
}
@media only screen and (max-width: 600px) {
  .svi-bar-container {
      width: 95%;
      min-width: 300px;
      max-width: 500px;
  }
  .svi-bar-child {
    align-items: center;
    display: grid;
    grid-template-columns: auto auto;
    justify-items: right;
    margin: 0px;
    margin-bottom: 10px;
    margin-top: 10px;
  }
  .svi-image {
    max-width: 60vw;
  }
}
</style>