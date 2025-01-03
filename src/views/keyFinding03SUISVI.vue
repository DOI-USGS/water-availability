<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
              <p>About 8% of the CONUS population, or 26.7 million people, live in areas of high or severe water limitation. The availability of clean water for our communities is affected by hydrologic factors like water quantity, quality, and flow, to social factors like water infrastructure, access, and rights.<span v-for="reference in theseReferences.filter(item => item.refID === 'Stets2025')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.refID }}</span></span> Socioeconomic status and access to resources and public services can determine a community's adaptive capacity, and ultimately how vulnerable or resilient a community may be when faced with water-availability limitations.</p>
            </div>

            <div class="text-container">
              <p class="chart-title">Social vulnerability and water limitation</p>
              <p class="chart-subtitle">Map shows each hydrologic unit (HUC8) scaled by social vulnerability score and colored by water limitation category.</p>
            </div>
            <div class="viz-container">
              <img class="viz-portrait" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/03_sui_popn_CONUS.png">
            </div>
            <div class="caption-container">
              <div class="caption-text-child">
                <p>Map showing circles for each hydrologic unit (HUC8). The color of the circle is the level of water limitation, and the size of the bubble represents the social vulnerability score, with larger bubbles representing more social vulnerability.<span v-for="reference in theseReferences.filter(item => item.refID === 'Census2020')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.refID }}</span></span></p>
              </div>
              <div class="caption-legend-child">
                <div class="legend_item" id="legend-sui-none" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                  Very low water limitation
                  </label>
                </div>
                <div class="legend_item" id="legend-sui-low" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                  Low water limitation
                  </label>
                </div>
                <div class="legend_item" id="legend-sui-mod" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                  Moderate water limitation
                  </label>
                </div>
                <div class="legend_item" id="legend-sui-high" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                  High water limitation
                  </label>
                </div>
                <div class="legend_item" id="legend-sui-severe" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                  Severe water limitation
                  </label>
                </div>

              </div>
            </div> 
            <div class="text-container">
                <h3>Social vulnerability is disproportionately high in areas of water limitation</h3>
                <p>Despite tremendous gains throughout the 20th century, limitations to water access and quality persist in the United States. These limitations disproportionately affect <a href="https://labs.waterdata.usgs.gov/visualizations/vulnerability-indicators/index.html#/en" target="_blank">socially vulnerable</a> communities, where societal factors shape exposure to hazards, susceptibility to suffer harm, and ability to cope and recover from losses (Drakes et al., 2024; Meehan et al., 2020; Mueller and Gasteyer, 2021; Scanlon et al., 2023). </p>
            </div>
            <div class="text-container">
              <p class="chart-title">Social vulnerability and water limitation</p>
              <p class="chart-subtitle">Bars show the proportion of the population living in varying levels of water limitation by social vulnerability classification. </p>
            </div>
            <div class="text-container">
              <img class="viz-portrait" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/03_sui_popn_bar.png">
            </div>
            <div class="caption-container">
              <div class="caption-text-child">
                <p>Bar charts showing the proportion of the population of the lower 48 United States living in varying categories of social vulnerability and water limitation. The color is the level of water limitation.<span v-for="reference in theseReferences.filter(item => item.refID === 'Census2020')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.refID }}</span></span></p>
              </div>
            </div> 
            <div class="text-container">
                <h3>Water quality also disproportionately limits water availability in socially vulnerable households</h3>
                <p>Exposure to drinking-water contamination occurs at higher rates for low-income communities, minority-dominated communities, and those who depend on domestic wells as their drinking water source, compared to communities who are not socially vulnerable (Erickson2025xxx). For example, the proportion of individuals with the highest levels of social vulnerability increases as the concentrations of total nitrogen and total phosphorus in streams goes up. While nitrogen and phosphorus pollution are problems for most communities in the U.S., watersheds with the highest levels of nitrogen and phosphorus contamination contain higher proportions of socially vulnerable individuals. These areas are relatively limited in spatial extent and have high population density, which emphasizes the impacts of highly developed, human-dominated watersheds to human health and wellbeing.</p>
            </div>
        <Methods></Methods>
        <References :theseReferences="referenceList"></References>
        </div>
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>
</template>

<script setup>
import { inject, ref, watch } from 'vue';
import { useRoute } from 'vue-router';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import references from './../assets/text/references.js';
import References from '../components/References.vue';
import SubPages from '../components/SubPages';
import ToggleSwitch from '../components/ToggleSwitch.vue';

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
const theseReferences = references.key.filter((item) => filteredReferences.includes(item.refID)) 
// sort by order listed on page, reflected in list on subpages.js
const sortedReferences = theseReferences.sort((a, b) => filteredReferences.indexOf(a.refID) - filteredReferences.indexOf(b.refID))
sortedReferences.forEach((item, index) => { item.referenceNumber = `${index + 1}`; }); // add numbers
const referenceList = ref(sortedReferences);

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


</script>

<style scoped>

</style>