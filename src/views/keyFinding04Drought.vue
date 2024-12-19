<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <h2>The water cycle of the U.S.</h2>
                <p>The water cycle describes how water moves through natural and human-modified landscapes. Water evaporates from the ocean and land into the atmosphere, where its movement is driven by wind. In the atmosphere, water condenses to form precipitation, which falls to the Earth's surface in the form of rain or snow. Precipitation that falls on land has many fates. It can stay on the landscape temporarily as snow or soil moisture, be stored in lakes or reservoirs, return to the atmosphere through evaporation or transpiration (the process by which plants lose water through the pores in their leaves), run off into streams and rivers eventually discharging into the ocean, or percolate more deeply to recharge groundwater. In the United States, a quarter of our daily water budget leaves through streamflow to Canada, the Atlantic and Pacific Oceans, or the Gulf of Mexico.</p>
                </div>
                <div class="viz-container">
                    <img class="viz-placeholder" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/04_watercycle.png">
                </div>
                <div class="text-container">
                    <p>As water moves through the water cycle it can spend different amounts of time in the various stages. For example, water that falls as snow could remain on the landscape for months until it melts in the spring, while water that makes its way into groundwater may remain for decades or longer. This means that periods of abnormally low precipitation affect different parts of the water cycle at different times. </p>
                  <br>
                    <p>During periods of low precipitation, less water in streams and rivers can lead to more groundwater use resulting in groundwater declines that may take years to recover. By assessing all parts of the water budget together, we can visualize how these changes are reflected in different parts of water cycle, and how they relate to water availability across the nation. For example, in 2012 the Northern High Plains had abnormally low precipitation, which cascaded through the water cycle with delayed responses in evapotranspiration, soil moisture, and eventually streamflow. Similarly, periods of 
                    rainfall in early 2011 did not show up in the streamflow signature until later in that year.</p>
                </div>
                <div class="caption-container">
                  <div class="caption-text-child">
                    <p>This map shows levels of water limitation for each watershed (HUC12). The bar chart shows the proportion of each water limitation category. Toggle the levels of water limitation on and off with these buttons. Hover over the map to see regional summaries.</p>
                  </div>
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

            <div class="text-container">
                <p>Precipitation and snowmelt improve quickflow, help fill streams, and can recharge the water available to plants in the ground. Soil moisture provides water for plants in the root zone and recycling water back to the atmosphere through plant transpiration and evaporation from bare soils (Legates et al., 2011). During summer months in the Souris-Red-Rainy, Texas, Southern High Plains, and Southwest Desert hydrologic regions soil moisture volumes are very low, indicating that the precipitation that falls during these times is directly lost to streamflow and/or plants and relatively little is partitioned to groundwater storage. 
                </p>
            </div>
            <Methods></Methods>
            <References></References>
        </div>
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>
</template>

<script setup>
import { ref, onMounted, inject } from 'vue';
import * as d3Base from 'd3';
import Reg from "../../public/assets/Regions.svg";
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import References from '../components/References.vue';

// global variables
const baseURL = "https://labs.waterdata.usgs.gov/visualizations/images/water-availability/04_ws_2010_";
const defaultRegionID = "Northern_High_Plains";
const imgSrc = ref(getImgURL(defaultRegionID)); 
const featureToggles = inject('featureToggles');
const focalFill = "var(--teal-dark)";
const defaultFill = "var(--default-fill)";

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

.highlight {
  color: white;
  padding: 0.25px 5px;
  border-radius: 10px;
  white-space: nowrap;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.1s;

  &#dry {
    background-color: var(--ws-demand);
  }

  &#wet {
    background-color: var(--ws-supply);
  }
}
</style>
