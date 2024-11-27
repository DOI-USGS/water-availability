<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <h2>The United States' water cycle</h2>
                <p>Water evaporates from the ocean and land into the atmosphere where its movement is driven by wind. In the atmosphere, it condenses to form precipitation which falls to the Earth's surface in the form of rain or snow. Precipitation that falls on land has many fates. It can be held temporally as snow or soil moisture, stored in lakes or reservoirs, return to the atmosphere through evaporation or transpiration (evapotranspiration), run off into streams and rivers eventually discharging into the ocean, or consumed by plants and animals. A small fraction of the precipitation that falls on land percolates more deeply to recharge groundwater. In the United States, a quarter of our daily water budget leaves through streamflow to Canada, the Atlantic and Pacific Oceans, or the Gulf of Mexico.</p>
                </div>
                <div class="viz-container">
                    <img class="viz-placeholder" src="../assets/images/manual/04_watercycle.png">
                </div>
                <div class="text-container">
                    <p>As water moves through the water cycle it can spend different amounts of time in the various stages. For example, water that falls as snow could remain on the landscape for months until it melts in the spring, while water that makes its way into groundwater may remain for decades or longer. This means that periods of abnormally low precipitation affect different parts of the water cycle at different times.</p>
                    <br><br>
                    <p> 
                      During periods of low precipitation, less water in streams and rivers can lead to more groundwater use resulting in groundwater declines that may take years to recover. By assessing all parts of the water budget together, we can visualize how these changes are reflected in different parts of water cycle, and how they relate to water availability across the nation.</p>
                    <br><br>
                    <p>Water supply cascades through the water cycle. For example, in 2012 the Northern High Plains had 
                        <span class="highlight" id="dry">abnormally low</span> precipitation, which cascaded through the water cycle with delayed responses in evapotranspiration, soil moisture, and eventually streamflow. Similarly, periods of  
                        <span class="highlight" id="wet">abnormally high</span>
                    rainfall in early 2011 did not show up in the streamflow signature until later in that year.</p>
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
                <h2>Disruptions to the water cycle can cause water stress</h2>

                <p> Streamflow is the flow of water in a natural channel on the land surface. Streamflow can be conceptualized as having two primary components: baseflow and quickflow. Quickflow is the short-term flow of water off the landscape following precipitation or snowmelt events. Quickflow is also often referred to as runoff. Baseflow is subsurface water that enters the stream channel from groundwater. Baseflow can maintain streamflow between precipitation events, if the groundwater level remains high enough to feed the stream. 
                </p>
            </div>
            <div class="viz-container">
                <img class="viz-double-portrait" src="../assets/images/manual/04_Prec.png">
                <img class="viz-double-portrait" src="../assets/images/manual/04_noPrec.png">
            </div>
            <div class="text-container">
                <p>Precipitation and snowmelt improve quickflow, help fill streams, and can recharge the water available to plants in the ground. Soil moisture provides water for plants in the root zone and recycling water back to the atmosphere through plant transpiration and evaporation from bare soils (Legates et al., 2011). During summer months in the Souris-Red-Rainy, Texas, Southern High Plains, and Southwest Desert hydrologic regions soil moisture volumes are very low, indicating that the precipitation that falls during these times is directly lost to streamflow and/or plants and relatively little is partitioned to groundwater storage. 
                </p>
                <h2>Water stress in the U.S.</h2>
                <p>The combination of low precipitation and little input to soil moisture, snow, or lakes and reservoirs are conditions that can cause water stress. Areas in the U.S. with water supply issues include the Southern, and Central High Plains, Texas, and the Southwest Desert regions. In many of these regions, groundwater supply fills this need, but an over reliance on slowly recharged groundwater resources has resulted in substantially lowered water levels.</p><br>

                
                <p>Extremely dry conditions were observed in greater than 25 percent of the Southeast aggregated region in 2011. In 2012, greater than 75 percent of the High Plains and greater than 60 percent of the Northeast-Midwest aggregated regions suffered extremely dry conditions due to anomalously low rainfall totals in spring and summer. These extremely dry conditions were associated with the most severe and widespread drought in the period of analysis and one of the most extreme droughts since the 1930s Dust Bowl (Hoerling and others, 2014; Bell and others, 2015). Learn more about this recent drought at <a href="https://labs.waterdata.usgs.gov/visualizations/drought-timeline/index.html#/" target="_blank">Five droughts that changed history</a></p>
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

const imgSrc = ref('https://labs.waterdata.usgs.gov/visualizations/images/water-availability/04_ws_2010_Northern High Plains.png');

const featureToggles = inject('featureToggles');

const setDefaultImgSrc = () => {
  import(`https://labs.waterdata.usgs.gov/visualizations/images/water-availability/04_ws_2010_Northern High Plains.png`).then(img => {
    imgSrc.value = img.default;
  });
};

const addInteractions = () => {
  const mapSVG = d3Base.select('.reg-svg');
  mapSVG.selectAll('.Region_nam_nospace')
    .on("mouseover", mouseoverMap)
    .on("mouseout", mouseoutMap);
};


const mouseoverMap = (event) => {
  const regionID = event.target.id;
  d3Base.select('.reg-svg').selectAll(`#${regionID}`).style("fill", "#5e7789");
  const formattedRegionID = regionID.replace(/_/g, ' ');
  import(`https://labs.waterdata.usgs.gov/visualizations/images/water-availability/04_ws_2010_${formattedRegionID}.png`).then(img => {
    imgSrc.value = img.default;
  });
};

const mouseoutMap = (event) => {
  const regionID = event.target.id;
  d3Base.select('.reg-svg').selectAll(`#${regionID}`).style("fill", "#d1cdc0");
  import(`https://labs.waterdata.usgs.gov/visualizations/images/water-availability/04_ws_2010_Northern High Plains.png`).then(img => {
    imgSrc.value = img.default;
  });
};

onMounted(() => {
  setDefaultImgSrc();
  addInteractions();
});

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
    background-color: #965a5b;
  }

  &#wet {
    background-color: #1687A5;
  }
}
</style>
