<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <p>The climate is changing. Land and ocean temperatures are increasing, atmospheric carbon dioxide is increasing, Arctic permafrost is melting, and sea levels are rising. Climate policies aim to limit these changes, but what happens if the global temperature rises 2.2°C by mid-21st century? How will a changing climate affect the water cycle in the U.S.? The answer will vary from region to region, but some future impacts of climate change are consistent across the U.S.</p>
            </div>
            <div class="viz-container">
              <tabsGroup id="impact-tabs" :options="{ useUrlFragment: false }">
                <tabItem 
                v-for="tab in impactTabs" 
                :name="tab.tabTitle" 
                :key="tab.tabTitleID" 
                :prefix="getIconImgHTML(tab.tabTitleID)"> 
                  <h3 class="tab-content-title">
                    <span class="impact-class" id="tab.tabTitleIDname">
                      <span id="tab.tabTitleID">
                        {{ tab.tabSubtitle }} 
                      </span>
                    </span>
                  </h3>
                  <div id="map-list">
                    <ul id="impact-list">
                        <li v-for="items in tab.listText"> {{ items }} </li>
                    </ul>
                    <img id="tab-content-image" :src="getMapURL(tab.tabTitleID)">
                    <img id="tab-legend" :src="getLegendURL(tab.tabTitleID)">
                  </div>
                  <p v-html="tab.tabText" />
                </tabItem>
              </tabsGroup>
            </div>
            <div class="text-container">
                <h3>Impacts from other aspects of the water cycle</h3>
                <p>Every region of the U.S. will experience some effects of climate change on water cycle processes that do not fall into any of the previous categories. For example, higher levels of atmospheric CO2 at the Earth's surface can increase plant transpiration (water evaporated through the pores in leaves), causing greater consumptive losses (transfer of soil water to the atmosphere leading to soil moisture depletion). Decreased surface albedo (reflectance) in the Arctic will lead to additional warming and additional melting of snow and ice. </p> 
                <br>
                <p>Interacting processes in the water cycle are likely to produce complex changes in regional-scale hydroclimate that will influence water availability for populations in the United States, including changes in mountain and coastal precipitation, aridification, and the influence of land-cover change on terrestrial water-vapor recycling.</p>
            </div>
            <Methods></Methods>
            <References></References>
        </div>
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>
</template>

<script setup>
import { inject, computed } from 'vue';
import { useRoute } from 'vue-router';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import References from '../components/References.vue';
import SubPages from '@/components/SubPages.js';
import { isMobile } from 'mobile-device-detect';

const featureToggles = inject('featureToggles');

const route = useRoute();

const path = computed(() => route.path)

// filter to this page's key message
const filteredMessages = SubPages.SubPages.filter(message => message.route === route.path);

// extract list of tab items for this page
const impactTabs = filteredMessages[0].tabData;

// global objects
const baseURL = "https://labs.waterdata.usgs.gov/visualizations/images/water-availability/"


function getMapURL(suffix) {
    return isMobile ? baseURL + `10_${suffix}-mobile.png` : baseURL + `10_${suffix}.png`
}
function getLegendURL(suffix) {
    return isMobile ? null : baseURL + `10_${suffix}_legend.png`
}
function getIconURL(suffix) {
    return baseURL + `future_${suffix}.png`
}
function getIconImgHTML(image_name) {
    const imgURL = getIconURL(image_name);
    return `<img class='tab-image' src=${imgURL}>`
}


</script>

<style>



</style>