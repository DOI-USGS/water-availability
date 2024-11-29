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
                    <img class="tab-content-image" :src="getMapUrl(tab.tabTitleID)">
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


function getMapUrl(suffix) {
    return isMobile ? baseURL + `10_${suffix}-mobile.png` : baseURL + `10_${suffix}.png`
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
#map-list {
    display: grid;
    grid-template-columns: 1fr 3fr;
    padding-bottom: 15px;
}
#impact-list{
    padding-top: 15px;
    padding-left: 15px;
}


@media only screen and (max-width: 768px) {
    #map-list {
        display: grid;
        grid-template-columns: 1fr;
    }
    #impact-list {
        padding-bottom: 10px;
    }
}

.impact-title {
    padding: 0px;
}
.impact-class {
    padding: 0px;
}
#impact-tabs {
    margin-top: 3rem;
}
ul {
    padding-inline-start: 0px;
}
li {
    padding: 0; 
}


.tabs-component {
    margin: auto;
    width: 100%;
}

@media (min-width: 850px) {
    .tabs-component {
        width: 90%;
    }
}
.tab-image {
    max-width: 2rem;
    max-height: 2rem;
    margin-right: 1rem;
    height: auto;
    width: auto;
}

@media (min-width: 850px) {
    .tab-image {
        max-width: fit-content;
        max-height: 5rem;
        margin-bottom: 1rem;
        height: 5rem;
        width: auto;
    }
}

.tabs-component-tab.is-inactive img {
    opacity: 0.5;
}
.tab-content-image {
    width: 100%;
}
.tab-content-title {
    padding: 0rem 0 1rem 0;
    line-height: 2.6rem;
}
/* css modified from vue-tabs-component demo: https://tabs-component.jakubpotocky.sk/ */
.tabs-component-tabs {
    border: solid 1px #ddd;
    border-radius: 6px;
    margin-bottom: 5px;
}


@media (min-width: 850px) {
    .tabs-component-tabs {
        border: 0;
        align-items: stretch;
        display: flex;
        justify-content: flex-start;
        margin-bottom: -1px;
    }
}

.tabs-component-tab {
    color: #999;
    font-size: 1.6rem;
    font-weight: 600;
    margin-right: 0;
    list-style: none;
}

.tabs-component-tab:not(:last-child) {
    border-bottom: dotted 1px #ddd;
}

.tabs-component-tab:hover {
    color: #666;
}

.tabs-component-tab.is-active {
    color: #000;
}
.tabs-component-tab.is-disabled * {
    color: #cdcdcd;
    cursor: not-allowed !important;
}


@media (min-width: 850px) {
    .tabs-component-tab {
        background-color: #fff;
        border: solid 1px #ddd;
        border-radius: 3px 3px 0 0;
        margin-right: .5em;
        /* transform: translateY(4px); */
        transition: transform .3s ease;
        font-size: 1.6rem;
        text-align: center;
    }

    .tabs-component-tab.is-active {
        border-bottom: solid 1px #fff;
        z-index: 2;
        transform: translateY(0);
    }
}


@media (min-width: 850px) {
    .tabs-component-tab-a {
        align-items: center;
        color: inherit;
        display: flex;
        flex-direction: column;
        padding: .75em 1em;
        text-decoration: none;
    }
}

.tabs-component-tab-a {
    align-items: center;
    color: inherit;
    display: flex;
    padding: .75em 1em;
    text-decoration: none;
}

.tabs-component-panels {
    padding: 2em 0;
}


@media (min-width: 850px) {
    .tabs-component-panels {
        background-color: #fff;
        border: solid 1px #ddd;
        border-radius: 0 6px 6px 6px;
        box-shadow: 0 0 10px rgba(0, 0, 0, .05);
        padding: 2em 2em;
    }
}


</style>