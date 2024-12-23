<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
          <div class="text-container">
            <p>The conditions that limit water availability often occur together. For example, areas with limited water supply can be more vulnerable to water quality issues and alterations to ecological flow. The relative impact of these factors varies from region to region, and regions that have water limitation arising from more than one indicator may pose the greatest challenges to resource managers. The four indicators of integrated water availablity were the amount of water (water quanity), the quality of surface and groundwater, and alterations to natural flow (ecoflows). Within each indicator, high limitation indicates areas where water quality or quantity conditions exceed the requirements, or sensitivity, for a particular use.<span v-for="reference in theseReferences.filter(item => item.refID === 'Stets2025')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.refID }}</span></span></p>
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
                    <!--p class="tab-content-text" v-html="tab.tabText" /-->
                    <p class="tab-content-text">
                      <span v-for="textChunk, index in tab.tabText" :key="textChunk.id">
                        <span v-if="index > 0 && textChunk.startofSentence">&nbsp;</span>
                        <span v-html="textChunk.text"/>
                        <span v-for="reference, index in theseReferences.filter(item => `${textChunk.refs}`.includes(item.refID))" :key="index" class="tooltip">   
                          <sup class="in-text-number">{{ reference.referenceNumber }} </sup> 
                          <span class="tooltiptext">
                            <span v-html="reference.refID" />
                          </span>
                          <span v-if="index < theseReferences.filter(item => `${textChunk.refs}`.includes(item.refID)).length - 1">
                            <sup class="in-text-number">,&nbsp;
                            </sup>
                          </span>
                        </span>
                      </span>
                    </p>
                  </div>
                </tabItem>
              </tabsGroup>
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
import { isMobile } from 'mobile-device-detect';

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