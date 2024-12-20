<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
              <p>About 8% of the CONUS population, or 26.7 million people, live in areas of high or severe water limitation. The availability of clean water for our communities is affected by hydrologic factors like water quantity, quality, and flow, to social factors like water infrastructure, access, and rights.<span v-for="reference in theseReferences.filter(item => item.refID === 'Stets2025')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.refID }}</span></span> Socioeconomic status and access to resources and public services can determine a community's adaptive capacity, and ultimately how vulnerable or resilient a community may be when faced with water-availability limitations.</p>
            </div>
            <div class="caption-container">
              <div class="caption-text-child">
                <p>These circles each represent one watershed (HUC12). The color is the level of water limitation, and the size of the bubble represents the population of people living in that watershed.<span v-for="reference in theseReferences.filter(item => item.refID === 'Census2020')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.refID }}</span></span></p>
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
            <div class="viz-container">
              <img class="viz-portrait" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/02_sui_popn_CONUS.png">
            </div>
            <div class="text-container">
                <h3>Social vulnerability is disproportionately high in areas of water limitation</h3>
                <p>Despite tremendous gains throughout the 20th century, limitations to water access and quality persist in the United States. These limitations disproportionately affect <a href="https://labs.waterdata.usgs.gov/visualizations/vulnerability-indicators/index.html#/en" target="_blank">socially vulnerable</a> communities, where societal factors shape exposure to hazards, susceptibility to suffer harm, and ability to cope and recover from losses (Drakes et al., 2024; Meehan et al., 2020; Mueller and Gasteyer, 2021; Scanlon et al., 2023). </p>
            </div>
            <div class="caption-container">
              <div class="caption-text-child">
                <p>This map shows areas of high and low water limitation by color, with socially vulnerable populations indicated with darker shades of those colors. For example, light blue indicates low water limitation and low social vulnerability, while dark red indicates high water limitation and high social vulnerability. Click on the button to view the areas of high water limitation. These areas show almost exclusively dark red patches, meaning that most areas with high water limitation occur where people are socially vulnerable. </p>
              </div>
              <div class="caption-legend-child">
                <div class="legend_item" id="legend-sui-none" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                  Very low water limitation
                  </label>
                </div>
                <div class="legend_item" id="legend-sui-mod-svi" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                  Moderate water limitation
                  </label>
                </div>
                <div class="legend_item" id="legend-sui-severe" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                  Severe water limitation
                  </label>
                </div>
                <div class="checkbox_item" id="checkbox-svi" >
                  <label class="checkbox_wrap">
                  <input type="checkbox" 
                  name="checkbox" 
                  class="checkbox_inp" 
                  @click="toggleViz">
                  <span class="checkbox_mark"></span>
                  {{ buttonText }}
                  </label>
                </div>
              </div>
            </div> 
            <div class="viz-container">
                <img 
                        id="first-image" 
                        class="viz-placeholder" 
                        :src="imgSrc" 
                        alt="xxx"
                    >
            </div>
            <div class="text-container">
                <h3>Water quality also disproportionately limits water availability in socially vulnerable households</h3>
                <p>Exposure to drinking-water contamination occurs at higher rates for low-income communities, minority-dominated communities, and those who depend on domestic wells as their drinking water source, compared to communities who are not socially vulnerable (Erickson2025xxx). For example, the proportion of individuals with the highest levels of social vulnerability increases as the concentrations of total nitrogen and total phosphorus in streams goes up. While nitrogen and phosphorus pollution are problems for most communities in the U.S., watersheds with the highest levels of nitrogen and phosphorus contamination contain higher proportions of socially vulnerable individuals. These areas are relatively limited in spatial extent and have high population density, which emphasizes the impacts of highly developed, human-dominated watersheds to human health and wellbeing.</p>
            </div>
        <Methods></Methods>
        <References></References>
        </div>
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>
</template>

<script setup>
import { inject, ref } from 'vue';
import { useRoute } from 'vue-router';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import references from './../assets/text/references.js';
import References from '../components/References.vue';
import SubPages from '../components/SubPages';

// global variables
const baseURL = "https://labs.waterdata.usgs.gov/visualizations/images/water-availability/";
const defaultImageID = "03_sui_svi_map";
const stressImageID = "03_sui_svi_dry_map";
let imgSrc = ref(getImgURL(defaultImageID));

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

let buttonText = "all levels";

function getImgURL(id) {
  return `${baseURL}${id}.png`;
}

function toggleViz() {
    if(imgSrc.value === getImgURL(defaultImageID)) {
        imgSrc.value = getImgURL(stressImageID);
        buttonText = "Only high levels";

    } else {
        imgSrc.value = getImgURL(defaultImageID);
        buttonText = "View all levels";

    }
}

</script>

<style scoped>

</style>