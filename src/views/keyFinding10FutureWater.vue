<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <p>The climate is changing. Land and ocean temperatures are increasing, atmospheric CO2 is increasing, sea levels are rising, and glaciers are melting. Climate policies aim to limit these changes, but what happens if the global temperature rises 2-2.4°C by mid-21st century? What does a changing climate mean for the national water cycle? The answer may vary from region to region, but some effects are more consistent than others.</p>
            </div>
            <div class="viz-container">
                <div class="gallery">
                    <input type="radio" checked="checked" name="select" id="kf10_temp">
                    <label for="kf10_temp" style="background-image: url('./icons/future_temp.png');"></label>
                    <img src="../assets/images/manual/10_temp.png" border="0">

                    <input type="radio" checked="checked" name="select" id="kf10_water">
                    <label for="kf10_water" style="background-image: url('./icons/future_water.png');"></label>
                    <img src="../assets/images/manual/10_water.png" border="0">

                    <input type="radio" checked="checked" name="select" id="kf10_dry">
                    <label for="kf10_dry" style="background-image: url('./icons/future_dry.png');"></label>
                    <img src="../assets/images/manual/10_dry.png" border="0">

                    <input type="radio" checked="checked" name="select" id="kf10_snow">
                    <label for="kf10_snow" style="background-image: url('./icons/future_ice.png');"></label>
                    <img src="../assets/images/manual/10_snow.png" border="0">

                    <input type="radio" checked="checked" name="select" id="kf10_coastal">
                    <label for="kf10_coastal" style="background-image: url('./icons/future_coastal.png');"></label>
                    <img src="../assets/images/manual/10_coastal.png" border="0">

                    <input type="radio" checked="checked" name="select" id="kf10_wind">
                    <label for="kf10_wind" style="background-image: url('./icons/future_wind.png');"></label>
                    <img src="../assets/images/manual/10_wind.png" border="0">
                </div>
            </div>
            <div class="text-container">
                <h2>Temperature Impacts</h2>
                <p>Researchers are highly confident that changes in temperature will affect water resources in every region in the U.S., including Alaska, Hawaii, and the Caribbean islands. Extreme heat amplifies the effects of drought and increases evaporative loss from reservoirs. High stream temperatures harm fish health, especially in native, cold-water fisheries. Higher temperatures also lead to warmer and shorter winters, meaning less snowfall and less time for the snow to permeate into the ground.</p>
                <h2>Water Availability Impacts</h2>
                <p>Changes in wet and dry conditions are a little more variable. Researchers are highly confident that extreme precipitation and flooding will affect Alaska, the Northeast, and the Southeast, and moderately confident that those wet events will affect the remaining regions of the U.S. We are already seeing more extreme precipitation and flooding events, like the recent catastrophe with Hurricane Helene in Asheville, North Carolina. Such extreme flooding events impair water quality; dry conditions increase fire weather; and variability in precipitation hurts agricultural production.</p>
                <h2>Aridity and Drought Impacts</h2>
                <p>researchers are highly confident that dry conditions, like increases in drought and changes in aridity, will affect every region of the country. Overall, we expect the amount and timing of streamflow to change, the demand for groundwater to increase, and stream baseflow (streamflow derived from groundwater not precipitation) to decrease. Dry conditions increase fire weather and affect socially vulnerable people in particular (Azadpour et al., 2024)</p>
                <h2>Snow and Ice Impacts</h2>
                <p>Researchers are highly confident that every region in the U.S. except Hawaii and the Caribbean islands will see changes in snow and ice. The extent of snow cover is already smaller, and snow melts sooner. Ice in lakes and rivers is declining, as are glaciers, leading to decreased meltwater for downstream areas. Permafrost is thawing, and the transition line between rain and snow is moving north (meaning we see more rain where we used to see snow).</p>
                <h2>Coastal Impacts</h2>
                <p>Researchers are highly confident that coastal effects of climate change will impact every region in the U.S. that borders an ocean, meaning every region except the Northern Plains and Midwest. Along with sea level rise we expect to see larger storm surges, an increased frequency and severity of coastal flooding, and greater intrusion of saltwater into freshwater aquifers. </p>
                <h2>Wind Impacts</h2>
                <p>The anticipated effects of wind on the water cycle vary from region to region. Researchers are highly confident that changes in wind will affect the Northwest and Southwest and moderately confident that they will affect the rest of the U.S., except Alaska. We expect to see an increase in severe windstorms, including sand and dust storms, as well as stronger hurricanes. </p>
                <h2>Other Impacts</h2>
                <p>Researchers are highly confident that every region of the U.S. will experience some effects of climate change on the water cycle that don’t fall into any of the previous categories. For example, higher levels of atmospheric CO2 at the Earth’s surface increases plant transpiration (the process by which plants lose water through the pores in their leaves). Decreased surface albedo (reflectance) in the Arctic leads to additional warming and additional melting of snow and ice.</p>
            </div>

            <div class="viz-container">
              <tabsGroup id="impact-tabs" :option="{ useUrlFragment: false }">
                <tabItem 
                v-for="tab in impactTabs" 
                :name="`<span class='tabHeader'>${tab.tabTitle}</span>`" 
                :key="tab.tabTitle" 
                :prefix="getIconImgHTML(tab.tabTitleID)">
                  <h3 class="tab-content-title">
                    <span id="`impact-${tab.tabTitleID}`">
                      <span id="tab.tabTitleID">
                        {{  tab.tabTitle }}
                      </span>
                    </span>
                  </h3>
                  <img class="tab-content-image" :src="getMapUrl(tab.tabTitleID)">
                  <p v-html="tab.tabText" />
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
import { inject, computed } from 'vue';
import { useRoute } from 'vue-router';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import References from '../components/References.vue';
import SubPages from '@/components/SubPages.js';

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
    return baseURL + `10_${suffix}.png`
}
function getIconURL(suffix) {
    return baseURL + `future_${suffix}.png`
}
function getIconImgHTML(image_name) {
    const imgURL = getIconURL(image_name)
    return `<img class='tab-image' src=${imgURL}>`
}


</script>

<style scoped>
.gallery {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr 1fr 1fr 1fr;
  grid-gap: 20px;
  grid-column-start: 1;
  grid-row-start: 1;
  grid-row-end: 3;
  align-content: start;
  max-width: 700px;
  margin: 0 auto;
  transition: all 150ms linear;
}

.gallery input[type="radio"] {
  display: none;
}

.gallery label {
  position: relative;
  display: block;
  padding-bottom: 60%;
  margin: 5px;
  cursor: pointer;
  background-repeat: no-repeat;
  background-size: cover;
  background-position: 50% 50%;
  background-size: 50px;
}

.gallery label:before {
  border: 1px solid #e3e3e3;
  content: '';
  position: absolute;
  left: -5px;
  right: -5px;
  bottom: -5px;
  top: -5px;
}

.gallery img {
  display: none;
  grid-column-start: 1;
  grid-column-end: 7;
  grid-row-start: 2;
  grid-row-end: 3;
  width: 100%;
  transition: all 150ms linear;
}

.gallery input[name="select"]:checked + label + img {
  display: block;
}

.gallery input[name="select"]:checked + label:before {
  border: 1px solid #000;
}

.species-title {
    padding: 1px 10px 2px 6px;
}
.species-class {
    border-radius: 10px;
    padding: 1px 10px 2px 0px;
    font-weight: 300;
    font-style: italic;
}
#impact-wind {
    border: 1px solid #3c475a;
}
#impact-temp {
    border: 1px solid #66768F;
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
    width: 90vw;
    max-width: 1000px;
}
@media (min-width: 850px) {
    .tabs-component {
        width: 70vw;
    }
}
.tab-image {
    max-width: 2.5rem;
    max-height: 2.5rem;
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
.subheading-container {
    margin: 1rem 0 1rem 0;
    height: 5rem;
}
.subheading-image {
    /* max-width: 5rem; */
    height: 5rem;
    margin: 0 1rem 0 1rem;
}
.subheading {
    padding: 0;
    display: inline-block;
    transform: translate(0%, -50%);
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

.tabs-component-tab, .tabs-component-tab--custom {
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
.tabs-component-tab.is-disabled *, .tabs-component-tab--custom.is-disabled * {
    color: #cdcdcd;
    cursor: not-allowed !important;
}

@media (min-width: 850px) {
    .tabs-component-tab, .tabs-component-tab--custom {
        background-color: #fff;
        border: solid 1px #ddd;
        border-radius: 3px 3px 0 0;
        margin-right: .5em;
        /* transform: translateY(4px); */
        transition: transform .3s ease;
        font-size: 1.6rem;
        text-align: center;
    }

    .tabs-component-tab.is-active, .tabs-component-tab--custom.is-active {
        border-bottom: solid 1px #fff;
        z-index: 2;
        transform: translateY(0);
    }
}

@media (min-width: 850px) {
    .tabs-component-tab-a, .tabs-component-tab-a--custom {
        align-items: center;
        color: inherit;
        display: flex;
        flex-direction: column;
        padding: .75em 1em;
        text-decoration: none;
    }
}

.tabs-component-tab-a, .tabs-component-tab-a--custom {
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

.tabs-component-btn {
  cursor: pointer;
  background: #e1ecf4;
  border-radius: 3px;
  border: 1px solid #7aa7c7;
  padding: 4px 8px;
  color: #39739d;
}

.tabs-component-btn:hover {
  background-color: #b3d3ea;
  color: #2c5777;
}

.tabs-component-btn:active {
  background-color: #a0c7e4;
  box-shadow: none;
  color: #2c5777;
}

.tabs-component-tab--custom {
    border-color: #e1ecf4;
    color: #68838d;
}

.tabs-component-tab--custom:hover {
    border-color: #e1ecf4;
    color: #39739d;
}

.tabs-component-tab--custom.is-active {
    color: #39739d;
    border-color: #7aa7c7;
    border-bottom: solid 1px #fff;
}

</style>