<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <p>Not all water withdrawn for human water use returns to the local environment. Some water is lost as consumptive use because it is evaporated, transpired, incorporated into products or crops, consumed by humans or livestock, or otherwise made unavailable for immediate use. A major category of consumptive water use is the evaporation and transpiration of water used for crop irrigation. Between 2010 and 2020, approximately 83,000 mgd (37% of total withdrawals from freshwater) were lost as consumptive water use in the lower 48 states across all water use categories. Crop irrigation accounted for 90% of the consumptive losses, whereas thermoelectric and public supply accounted for only 3% and 7%, respectively (Medalie et al., 2025).</p>
            </div>
            <div class="viz-container">
                <img class="viz-placeholder" src="https://water-visualizations-prod-website.s3.us-west-2.amazonaws.com/visualizations/images/water-availability/09_cu_overview.png">
            </div>
            <div class="viz-container">
                <tabsGroup class="tab-group" :options="{ useUrlFragment: false }">
                    <tabItem 
                    v-for="tab in impactTabs" 
                    :name="tab.tabTitle" 
                    :key="tab.tabTitleID" 
                    :prefix="getIconImgHTML(tab.tabTitleID)"> 
                        <div class="tab-container-text-img">
                            <h3 class="tab-content-title">
                                {{ tab.tabSubtitle }} 
                            </h3>
                            <img class="tab-content-img" :src="getPhotoURL(tab.tabTitleIDname)">
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
import { ref, inject, computed } from 'vue';
import { useRoute } from 'vue-router';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import References from '../components/References.vue';
import SubPages from '../components/SubPages';
import { isMobile } from 'mobile-device-detect';

const featureToggles = inject('featureToggles');

const route = useRoute();
const path = computed(() => route.path)
// filter to this page's key message
const filteredMessages = SubPages.SubPages.filter(message => message.route === route.path);
// extract list of tab items for this page
const impactTabs = filteredMessages[0].tabData;
// global objects
const baseURL = "https://water-visualizations-prod-website.s3.us-west-2.amazonaws.com/visualizations/images/water-availability/"

// tab functions
function getPhotoURL(suffix) {
    return baseURL + `09_cu_${suffix}.png`
}
function getIconURL(suffix) {
    return baseURL + `07_icon_${suffix}.png`
}
function getIconImgHTML(image_name) {
    const imgURL = getIconURL(image_name);
    return `<img class='tab-image' src=${imgURL}>`
}
</script>

<style scoped>

</style>