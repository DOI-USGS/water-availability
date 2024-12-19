<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
              <p>The availability of clean water for our communities is affected by hydrologic factors like water quantity, quality, and flow, to social factors like water infrastructure, access, and rights (xxx). Socioeconomic status and access to resources and public services can determine a community's adaptive capacity, and ultimately how vulnerable or resilient a community may be when faced with water-availability limitations.</p>
              <br>
              <p>These circles each represent one watershed (HUC8) in the U.S., and the size corresponds to the population living within that watershed (xx). Levels of water limitation are <span class="highlight" id="very_low_none"> very low or none </span>, <span class="highlight" id="low"> low </span>, <span class="highlight" id="moderate"> moderate </span>, <span class="highlight" id="high"> high </span>, and <span class="highlight" id="severe"> severe </span>.     </p>
            </div>
            <div class="viz-container">
              <img class="viz-portrait" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/02_sui_popn_CONUS.png">
            </div>
            <div class="text-container">
                <p>Despite tremendous gains throughout the 20th century, limitations to water access and quality persist in the United States. These limitations disproportionately affect <a href="https://labs.waterdata.usgs.gov/visualizations/vulnerability-indicators/index.html#/en" target="_blank">socially vulnerable</a> communities, where societal factors shape exposure to hazards, susceptibility to suffer harm, and ability to cope and recover from losses (Drakes et al., 2024; Meehan et al., 2020; Mueller and Gasteyer, 2021; Scanlon et al., 2023). For example, drinking-water violations in the U.S. are more prevalent in socially vulnerable communities based on socioeconomic status, race, language, and demographic and housing characteristics (Scanlon et al., 2023). In addition, cases of incomplete plumbing have been reported to be associated with communities of color, high poverty levels, low average income, low education rates, and renter-dominated communities (Deitz and Meehan, 2019; Meehan et al., 2020; Mueller and Gasteyer, 2021). Characteristics of a community, such as socioeconomic status or access to resources and public services, can determine a community’s adaptive capacity, and ultimately how vulnerable or resilient a community may be when faced with water-availability limitations.</p>
                <h3>Social vulnerability is disproportionately high in areas of water limitation</h3>
                <p>The overall balance between water supply and demand is quantified as water stress, which is calculated by comparing surface water-supply and consumptive uses. Although 8% of Americans living in the lower 48 states (27 million individuals) live in watersheds with high or severe water stress, more than half of this population belongs to the most socially vulnerable populations. </p>
                <br>
                <p>This map shows areas of high and low water limitation by color, with socially vulnerable populations indicated with darker shades of those colors. Click on the button to view the areas of high water limitation. These areas show almost exclusively dark red patches, meaning that most areas with high water limitation occur where people are socially vulnerable. </p>
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
                <h3>For socially vulnerable households, water quality is a limitation to water availability</h3>
                <p>Exposure to drinking-water contamination occurs at higher rates for low-income communities, minority-dominated communities, and those who depend on domestic wells as their drinking water source, compared to communities who are not socially vulnerable. For example, the proportion of individuals with the highest levels of social vulnerability increases as the concentrations of total nitrogen and total phosphorus in streams goes up. While nitrogen and phosphorus pollution are problems for most communities in the U.S., watersheds with the highest levels of nitrogen and phosphorus contamination contain higher proportions of socially vulnerable individuals. These areas are relatively limited in spatial extent and have high population density, which emphasizes the impacts of highly developed, human-dominated watersheds to human health and wellbeing.</p>
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
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import References from '../components/References.vue';

// global variables
const baseURL = "https://labs.waterdata.usgs.gov/visualizations/images/water-availability/";
const defaultImageID = "03_sui_svi_map";
const stressImageID = "03_sui_svi_dry_map";
let imgSrc = ref(getImgURL(defaultImageID));

const featureToggles = inject('featureToggles');

let buttonText = "all levels";

function getImgURL(id) {
  return `${baseURL}${id}.png`;
}

function showStress() {
    if(imgSrc.value === getImgURL(defaultImageID)) {
        imgSrc.value = getImgURL(stressImageID);
        buttonText = "only high levels";

    } else {
        imgSrc.value = getImgURL(defaultImageID);
        buttonText = "all levels";

    }
}

</script>

<style scoped>

</style>