<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <h2>The water cycle of the U.S.</h2>
                <p>The water cycle describes how water moves through natural and human-modified landscapes. In the United States, a quarter of our daily water budget leaves through streamflow to Canada, the Atlantic and Pacific Oceans, or the Gulf of Mexico.</p>
                </div>
                <div class="viz-container">
                    <img class="viz-placeholder" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/04_watercycle.png">
                </div>
                <div class="caption-container">
                  <div class="caption-text-child">
                    <p>Diagram showing average annual water cycle fluxes in billion gallons per day (bgd) across the lower 48 United States (cite models)</p>
                  </div>
                </div>  
                <br>
                <div class="text-container">
              <h3>Even short events have longlasting impacts</h3>
                    <p>As water moves through the water cycle it can spend different amounts of time in the various stages. Water that falls as snow could remain on the landscape for months until it melts in the spring. Water that makes its way into groundwater may remain for decades or longer. This means that periods of abnormally low precipitation affect different parts of the water cycle at different times. </p>
                  <br>
                    <p>For example, in 2012 the Northern High Plains had abnormally low precipitation, which cascaded through the water cycle. In the monthly fluctuations shown below, this low precipitation is followed by delayed responses in evapotranspiration and soil moisture. both important aspects of water supply. This eventually leads to reduced streamflow. Similarly, periods of rainfall in early 2011 did not show up in the streamflow signature until later in that year. </p>
                </div>
            <div class="chart-title-container">
                <p class="chart-title">Water supply dynamics in the {{ regionTitle }}</p>
                <p class="chart-subtitle">Monthly fluctuations in four aspects of water supply compared to normal for hydrologic regions of the lower 48 United States</p>
            </div>
            <div class="viz-container">
                <Reg class="reg-svg"></Reg>
                <img
                    class="viz-portrait"
                    id="cascades"
                    :src="imgSrc"
                    alt=""
                >    
            </div>
            <br>
            <div class="caption-container-flex caption-container">
              <div class="legend-group">
                <ColorLegend legend-id="legend-ws-high" label="Abnormally high water" color="var(--ws-supply)" />
                <ColorLegend legend-id="legend-ws-low" label="Abnormally low water" color="var(--ws-demand)" />
                        </div>
              <div class="caption-text-flex caption-text-child">
                <p>Bar chart showing monthly values of precipitation, evapotranspiration, soil moisture, and streamflow as compared to normal conditions for each hydrologic region (cite Van Meter) in the lower 48 United States. The values are normalized for comparison from 2010 through 2020, and thus do not have units. Select a region on the map to view bar charts for that region.</p>
              </div>
            </div> 
            <br>
            <br>
            <div class="text-container">
              <p>During periods of low precipitation, less water in streams and rivers can lead to more groundwater use resulting in groundwater declines that may take years to recover. By assessing all parts of the water budget together, we can better understand national water availability now and for the future.</p>
            </div>
            <br>
            <br>
            <Methods></Methods>
            <References :theseReferences="referenceList"></References>
        </div>
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>
</template>

<script setup>
import { ref, onMounted, inject } from 'vue';
import { useRoute } from 'vue-router';
import * as d3Base from 'd3';
import Reg from "../../public/assets/Regions.svg";
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import references from '../assets/text/references.js';
import References from '../components/References.vue';
import SubPages from '../components/SubPages.js';
import ColorLegend from '../components/ColorLegend.vue';

// global variables
const baseURL = "https://labs.waterdata.usgs.gov/visualizations/images/water-availability/04_ws_2010_";
const defaultRegionID = "Northern_High_Plains";
const imgSrc = ref(getImgURL(defaultRegionID)); 
const featureToggles = inject('featureToggles');
const focalFill = "var(--focal-fill)";
const defaultFill = "var(--inactive-grey)";
let regionTitle = defaultRegionID.replaceAll("_", " ") + " Region"

const route = useRoute();

// References logic
// filter to this page's key message
const filteredMessages = SubPages.SubPages.filter(message => message.route === route.path);
const filteredReferences = filteredMessages[0].references;// extract list of references for this page
const refArray = references.key.sort((a, b) => a.authors.localeCompare(b.authors)); // Sort references
const theseReferences = refArray.filter((item) => filteredReferences.includes(item.refID)) // extract references that match the refID from global list
theseReferences.forEach((item, index) => { item.referenceNumber = `${index + 1}`; }); // add numbers
const referenceList = ref(theseReferences);

// functions called here
onMounted(() => {
  addInteractions();

  // select default region to start
  d3Base.select('.reg-svg').selectAll(`#${defaultRegionID}`).style("fill", focalFill);
});

// Methods
function getImgURL(id) {
  return new URL(`${baseURL}${id}.png`);
}

function addInteractions() {
  const mapSVG = d3Base.select('.reg-svg');
  mapSVG.selectAll('.Region_nam_nospace')
    .on("mouseover", mouseoverMap)
    .on("mouseout", mouseoutMap);
};

function mouseoverMap(event) {
  const regionID = event.target.id;
  d3Base.select('.reg-svg').selectAll(`#${defaultRegionID}`).style("fill", defaultFill);
  d3Base.select('.reg-svg').selectAll(`#${regionID}`).style("fill", focalFill);
  imgSrc.value = getImgURL(regionID);
  regionTitle = regionID.replaceAll("_", " ") + " Region";
};

function mouseoutMap(event) {
  const regionID = event.target.id;
  d3Base.select('.reg-svg').selectAll(`#${regionID}`).style("fill", defaultFill);
  d3Base.select('.reg-svg').selectAll(`#${defaultRegionID}`).style("fill", focalFill);
  imgSrc.value = getImgURL(defaultRegionID);
  regionTitle = defaultRegionID.replaceAll("_", " ") + " Region";
};

</script>

<style scoped>

</style>
