<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
              <p>About 26.7 million people, or 8% of the population, live in areas of high or severe water limitation. The availability of clean water for our communities is affected by hydrologic factors like water quantity, quality, and flow, as well as social factors like water infrastructure, access, and rights.<span v-for="reference in theseReferences.filter(item => item.refID === 'Stets2025')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.refID }}</span></span> Socioeconomic status and access to resources and public services can determine a community's adaptive capacity, and ultimately how vulnerable or resilient a community may be when faced with water-availability limitations.</p>
            </div>

            <div class="chart-title-container">
              <p class="chart-title">How does social vulnerability relate to water limitation?</p>
              <p class="chart-subtitle">Map shows each hydrologic unit (HUC8) scaled by social vulnerability score and colored by water limitation category.</p>
            </div>
            <div class="viz-container">
              <img class="viz-placeholder" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/03_sui_popn_CONUS.png">
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
                <p>Map showing circles for each hydrologic unit (HUC8). The color of the circle is the level of water limitation, and the size of the bubble represents the social vulnerability score, with larger bubbles representing more social vulnerability.<span v-for="reference in theseReferences.filter(item => item.refID === 'Census2020')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.refID }}</span></span></p>
              </div>
            </div> 
            <br>
            <div class="text-container">
                <h2>Water insecurity</h2>
                <p>Despite tremendous gains throughout the 20th century, limitations to water access and quality persist in the United States. These limitations disproportionately affect <a href="https://labs.waterdata.usgs.gov/visualizations/vulnerability-indicators/index.html#/en" target="_blank">socially vulnerable</a> communities. Societal factors shape exposure to hazards, susceptibility to suffer harm, and ability to cope and recover from losses (Drakes et al., 2024). </p>
            </div>
            <div class="chart-title-container">
              <p class="chart-title">Social vulnerability and water limitation</p>
              <p class="chart-subtitle">Bars show the proportion of the population living in varying levels of water limitation for each social vulnerability classification. </p>
            </div>
            <div class="text-container">
              <img class="viz-portrait" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/03_sui_popn_bar.png">
            </div>
            <div class="caption-container">
              <div class="caption-text-child">
                <p>Bar charts showing the proportion of the population of the lower 48 United States living in varying categories of social vulnerability and water limitation. The color is the level of water limitation.<span v-for="reference in theseReferences.filter(item => item.refID === 'Census2020')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.refID }}</span></span></p>
              </div>
            </div> 
            <br>
            <div class="text-container">
                <h2>Access to clean water</h2>
                <p>Exposure to drinking-water contamination occurs at higher rates for low-income communities, minority-dominated communities, and those who depend on domestic wells as their drinking water source, compared to communities who are not socially vulnerable (Erickson2025xxx). While nitrogen and phosphorus pollution are problems for most communities in the U.S., watersheds with the highest levels of nitrogen and phosphorus contamination contain relatively higher proportions of socially vulnerable individuals. </p>
            </div>
            <br>
        <Methods></Methods>
        <References :theseReferences="referenceList"></References>
        </div>
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>
</template>

<script setup>
import { inject, ref, watch, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import references from './../assets/text/references.js';
import References from '../components/References.vue';
import SubPages from '../components/SubPages';
import ColorLegend from '../components/ColorLegend.vue';

// global variables
const baseURL = "https://labs.waterdata.usgs.gov/visualizations/images/water-availability/";
const defaultImageID = "03_sui_svi_map";
const stressImageID = "03_sui_svi_dry_map";
let imgSrc = ref(getImgURL(defaultImageID));

// toggle state
const showHighLevelsOnly = ref(false);

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

// Methods
function getImgURL(id) {
  return `${baseURL}${id}.png`;
}

watch(showHighLevelsOnly, (newValue) => {
    if (newValue) {
        imgSrc.value = getImgURL(stressImageID); // switch to high levels image
    } else {
        imgSrc.value = getImgURL(defaultImageID); // switch back to all levels image
    }
});

onMounted(() => {
  window.scrollTo(0, 0)
})

</script>

<style scoped>
.viz-scaled {
  max-height: 500px;
}
</style>