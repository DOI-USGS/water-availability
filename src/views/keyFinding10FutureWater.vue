<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <p>The climate is changing. Land and ocean temperatures are increasing, atmospheric CO<sub>2</sub> is increasing, Arctic permafrost is melting, and sea levels are rising. Climate policies aim to limit these changes, but what happens if the global temperature rises over 2°F by mid-21st century? How will a changing climate affect the water cycle in the U.S.? The answer will vary from region to region, but some future impacts of climate change are consistent across the U.S.</p>
            </div>
            <div class="text-container">
                <h3>Potential impacts from rising temperature</h3>
            </div>
            <div class="viz-container">
                <img class="viz-double-portrait" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/10_temp-mobile.png"/>
                <ul class="tab-content-list">
                    <li class="impact-list-items">Increased average air temperature</li>
                    <li>More common extreme heat events</li>
                    <li>Amplified drought events</li>
                    <li>Increased evaporative water loss</li>
                    <li>Decreased cold-water fish populations and habitat</li>
                    <li>Warmer and shorter winter season</li>
                    <li>Decreased frost and cold</li>
                </ul>
            </div>
            <div class="text-container">
                <h3>Potential impacts from wetter conditions</h3>
            </div>
            <div class="viz-container">
                <img class="viz-double-portrait" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/10_water-mobile.png"/>
                <ul class="tab-content-list">
                    <li class="impact-list-items">Increased average air temperature</li>
                    <li>Increased mean precipitation</li>
                    <li>More extreme precipitation and flooding</li>
                    <li>Changes in streamflow amount and timing</li>
                    <li>Effects on agriculture</li>
                    <li>Impaired water quality</li>
                </ul>
            </div>
            <div class="text-container">
                <h3>Potential impacts from drier conditions</h3>
            </div>
            <div class="viz-container">
                <img class="viz-double-portrait" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/10_dry-mobile.png"/>
                <ul class="tab-content-list">
                    <li class="impact-list-items">Increased groundwater demand</li>
                    <li>Changes in streamflow amount and timing</li>
                    <li>Effects on agriculture</li>
                    <li>Impaired water quality</li>
                    <li>More frequent and long-lasting fire weather</li>
                    <li>Amplified drought events</li>
                </ul>
            </div>
            <div class="text-container">
                <h3>Potential impacts from changing snow and ice</h3>
            </div>
            <div class="viz-container">
                <img class="viz-double-portrait" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/10_ice-mobile.png"/>
                <ul class="tab-content-list">
                    <li>Decreased snowfall</li>
                    <li>Earlier snowmelt runoff</li>
                    <li>Decreased lake and river ice extent</li>
                    <li>Reduced snow cover extent and duration</li>
                    <li>Decreased glaciers and increasing meltwater</li>
                    <li>Thawing permafrost</li>
                    <li>Altered rain and snow patterns</li>
                </ul>
            </div>
            <div class="text-container">
                <h3>Potential impacts from changing winds</h3>
            </div>
            <div class="viz-container">
                <img class="viz-double-portrait" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/10_wind-mobile.png"/>
                <ul class="tab-content-list">
                    <li>Decreased average wind speed</li>
                    <li>Increased sand and dust storms</li>
                    <li>Stronger hurricanes</li>
                    <li>Increased severe wind storms</li>
                    <li>Increased erosion</li>
                </ul>
            </div>
            <div class="text-container">
                <h3>Potential impacts from coastal change</h3>
            </div>
            <div class="viz-container">
                <img class="viz-double-portrait" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/10_coastal-mobile.png"/>
                <ul class="tab-content-list">
                    <li>Rising sea levels</li>
                    <li>Increased storm surge</li>
                    <li>Increased saltwater intrusion</li>
                    <li>Increased frequency and severity of coastal flooding</li>
                </ul>
            </div>
            <div class="text-container">
                <h3>Impacts from other aspects of the water cycle</h3>
                <p>Every region of the U.S. will experience some effects of climate change on water cycle processes that do not fall into any of the previous categories. For example, higher levels of atmospheric CO<sub>2</sub> at the Earth's surface can increase plant transpiration, which is the water evaporated through pores in leaves. Increased transpiration may causing greater transfer of soil water to the atmosphere leading to soil moisture depletion. Decreased surface albedo (reflectance) in the Arctic will lead to additional warming and additional melting of snow and ice. </p>
            </div>
            <Methods></Methods>
            <References :theseReferences="referenceList"></References>
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
import SubPages from '@/components/SubPages.js';

const featureToggles = inject('featureToggles');

const route = useRoute();

// References logic
// filter to this page's key message
const filteredMessages = SubPages.SubPages.filter(message => message.route === route.path);
const filteredReferences = filteredMessages[0].references;// extract list of references for this page
const refArray = references.key.sort((a, b) => a.authors.localeCompare(b.authors)); // Sort references
const theseReferences = refArray.filter((item) => filteredReferences.includes(item.refID)) // extract references that match the refID from global list
theseReferences.forEach((item, index) => { item.referenceNumber = `${index + 1}`; }); // add numbers
const referenceList = ref(theseReferences);

</script>

<style>



</style>