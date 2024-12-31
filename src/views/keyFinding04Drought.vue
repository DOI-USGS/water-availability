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
                <div class="text-container">
                    <p>As water moves through the water cycle it can spend different amounts of time in the various stages. Water that falls as snow could remain on the landscape for months until it melts in the spring. Water that makes its way into groundwater may remain for decades or longer. This means that periods of abnormally low precipitation affect different parts of the water cycle at different times. </p>
                  <br>
                    <p>During periods of low precipitation, less water in streams and rivers can lead to more groundwater use resulting in groundwater declines that may take years to recover. By assessing all parts of the water budget together, we can see how they are connected. For example, in 2012 the Northern High Plains had abnormally low precipitation, which cascaded through the water cycle with delayed responses in evapotranspiration, soil moisture, and eventually streamflow. Similarly, periods of 
                    rainfall in early 2011 did not show up in the streamflow signature until later in that year.</p>
                </div>
                <div class="caption-container">
                  <div class="caption-legend-child">
                    <div class="legend_item" id="legend-ws-low" >
                      <label class="legend_wrap">
                      <input type="legend" name="legend" class="legend-inp">
                      <span class="legend_mark"></span>
                        Abnormally low water
                      </label>
                    </div>
                    <div class="legend_item" id="legend-ws-high" >
                      <label class="legend_wrap">
                      <input type="legend" name="legend" class="legend-inp">
                      <span class="legend_mark"></span>
                        Abnormally high water
                      </label>
                    </div>
                  </div>
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
                <div class="caption-container">
                  <div class="caption-legend-child">
                <div class="caption-text-child">
                    <p>Monthly values of precipitation, evapotranspiration, soil moisture, and streamflow compared to normal conditions. The values are normalized for comparison, and thus do not have units. Hover over the map to see regional patterns.</p>
                  </div>
                  <br/>
                  <br/>
                </div>
              </div>
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

// global variables
const baseURL = "https://labs.waterdata.usgs.gov/visualizations/images/water-availability/04_ws_2010_";
const defaultRegionID = "Northern_High_Plains";
const imgSrc = ref(getImgURL(defaultRegionID)); 
const featureToggles = inject('featureToggles');
const focalFill = "var(--focal-fill)";
const defaultFill = "var(--inactive-grey)";


const route = useRoute();

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

// functions called here
onMounted(() => {
  addInteractions();

  // select default region to start
  d3Base.select('.reg-svg').selectAll(`#${defaultRegionID}`).style("fill", focalFill);
});

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
  imgSrc.value = getImgURL(regionID)
};

function mouseoutMap(event) {
  const regionID = event.target.id;
  d3Base.select('.reg-svg').selectAll(`#${regionID}`).style("fill", defaultFill);
  d3Base.select('.reg-svg').selectAll(`#${defaultRegionID}`).style("fill", focalFill);
  imgSrc.value = getImgURL(defaultRegionID)
};

</script>

<style scoped>

</style>
