<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
          <div class="text-container">
            <p>The conditions that limit water availability, often occur together. For example, areas with limited water supply can be more vulnerable to water quality issues and alterations to ecological flow. The relative impact of these factors varies from region to region, and regions that have water limitation arising from more than one indicator may pose the greatest challenges to resource managers.</p>
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
                    <img class="tab-content-legend" src="https://water-visualizations-prod-website.s3.us-west-2.amazonaws.com/visualizations/images/water-availability/02_water_avail_legend.png">
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
const baseURL = "https://water-visualizations-prod-website.s3.us-west-2.amazonaws.com/visualizations/images/water-availability/"


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

.highlight {
  color: white;
  padding: 0.25px 5px;
  border-radius: 10px;
  white-space: nowrap;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.1s;


  &#very_low_none {
    background-color: var(--sui-none);
  }

  &#low {
    background-color: var(--sui-low);
    color: black;
  }

  &#moderate {
    background-color: var(--sui-mod);
    color: black;
  }

  &#high {
    background-color: var(--sui-high);
    color: black;
  }

  &#severe {
    background-color: var(--sui-severe);
  }
}

</style>