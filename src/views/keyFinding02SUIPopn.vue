<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
          <div class="text-container">
            <p>The availability of clean water for our communities is affected by interrelated issues from hydrological (water quantity, quality, and flow) to social (water infrastructure, access, and rights). Physical infrastructure, such as public-supply (or self-supply) facilities, household-level plumbing, wells, dams, reservoirs, and diversions, are critical for meeting local water demands. Treaties, water compacts, and other legal agreements also determine access at multiple scales from household and municipal to internationally shared water resources. Additionally, characteristics of a community, such as socioeconomic status or access to resources and public services, can determine a community's adaptive capacity, and ultimately how vulnerable or resilient a community may be when faced with water-availability limitations.</p>
            <br>
            <p>These circles each represent one watershed (HUC8) in the U.S., and the size corresponds to the population living within that watershed (U.S. Census Bureau, 2020). Levels of water limitation are <span class="highlight" id="very_low_none"> very low or none </span>, <span class="highlight" id="low"> low </span>, <span class="highlight" id="moderate"> moderate </span>, <span class="highlight" id="high"> high </span>, and <span class="highlight" id="severe"> severe </span>.     </p>
          </div>

          <div class="viz-container">
            <img class="viz-portrait" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/02_sui_popn_CONUS.png">
          </div>
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

.highlight {
  color: white;
  padding: 0.25px 5px;
  border-radius: 10px;
  white-space: nowrap;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.1s;


  &#very_low_none {
    background-color: #39424f;
  }

  &#low {
    background-color: #80909D;
    color: black;
  }

  &#moderate {
    background-color: #edeadf;
    color: black;
  }

  &#high {
    background-color: #Cfacab;
    color: black;
  }

  &#severe {
    background-color: #965a6b;
  }
}

</style>