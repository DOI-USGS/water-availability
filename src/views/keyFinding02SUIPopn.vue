<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
          <div class="text-container">
            <p>The conditions that limit water availability often occur together. For example, areas with limited water supply can be more vulnerable to water quality issues and alterations to ecological flow. The relative impact of these factors varies from region to region, and regions that have water limitation arising from more than one indicator may pose the greatest challenges to resource managers. The four indicators of integrated water availablity were the amount of water (water quanity), the quality of surface and groundwater, and alterations to natural flow (ecoflows). Within each indicator, high limitation indicates areas where water quality or quantity conditions exceed the requirements, or sensitivity, for a particular use. </p>
          </div>
          <div class="viz-container">
              <tabsGroup class="tab-group" :options="{ useUrlFragment: false }">
                <tabItem 
                v-for="tab in impactTabs" 
                :name="tab.tabTitle" 
                :key="tab.tabTitleID" 
                :prefix="getIconImgHTML(tab.tabTitleIDname)"> 
                  <div class="tab-container-text-img-legend">
                    <h3 class="tab-content-title">
                      {{ tab.tabSubtitle }}
                    </h3>
                    <img class="tab-content-img" :src="getMapURL(tab.tabTitleIDname)">
                    <img class="tab-content-legend" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/02_water_avail_legend.png">
                    <p class="tab-content-text" v-html="tab.tabText" />
                  </div>
                </tabItem>
              </tabsGroup>
            </div>
          <Methods></Methods>
          <References></References>
        </div>
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>
</template>

<script setup>
import {inject} from 'vue';
import { useRoute } from 'vue-router';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import References from "../components/References.vue";
import SubPages from '../components/SubPages';
import { isMobile } from 'mobile-device-detect';

const route = useRoute();
const featureToggles = inject('featureToggles');

// filter to this page's key message
const filteredMessages = SubPages.SubPages.filter(message => message.route === route.path);

// extract list of tab items for this page
const impactTabs = filteredMessages[0].tabData;
console.log(impactTabs)

// global objects
const baseURL = "https://labs.waterdata.usgs.gov/visualizations/images/water-availability/"


function getMapURL(suffix) {
    return isMobile ? baseURL + `02_water_avail_wa_${suffix}.png` : baseURL + `02_water_avail_wa_${suffix}.png`
}
function getIconURL(suffix) {
    return baseURL + `02_icon_${suffix}.png`
}
function getIconImgHTML(image_name) {
    const imgURL = getIconURL(image_name);
    return `<img class='tab-image' src=${imgURL}>`
}

</script>

<style scoped>


</style>