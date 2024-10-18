<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <h2>The United States' water cycle</h2>
                <p>Water evaporates from the ocean and land into the atmosphere where its movement is driven by wind. In the atmosphere, it condenses to form precipitation which falls to the Earth's surface in the form of rain or snow. Precipitation that falls on land has many fates. It can be held temporally as snow or soil moisture, stored in lakes or reservoirs, return to the atmosphere through evaporation or transpiration (evapotranspiration), run off into streams and rivers eventually discharging into the ocean, or consumed by plants and animals. A small fraction of the precipitation that falls on land percolates more deeply to recharge groundwater. In the United States, a quarter of our daily water budget leaves through streamflow to Canada, the Atlantic and Pacific Oceans, or the Gulf of Mexico.</p>
                </div>
                <div class="viz-container">
                    <img class="viz-placeholder" src="../../public/images/k04_watercycle.png">
                </div>
                <div class="text-container">
                <h2>Disruptions to the water cycle can cause water stress</h2>

                <p> Streamflow is the flow of water in a natural channel on the land surface. Streamflow can be conceptualized as having two primary components: baseflow and quickflow. Quickflow is the short-term flow of water off the landscape following precipitation or snowmelt events. Quickflow is also often referred to as runoff. Baseflow is subsurface water that enters the stream channel from groundwater. Baseflow can maintain streamflow between precipitation events, if the groundwater level remains high enough to feed the stream. 
                </p>
            </div>
            <div class="viz-container">
                <img class="viz-double-portrait" src="../../public/images/k04_Prec.png">
                <img class="viz-double-portrait" src="../../public/images/k04_noPrec.png">
            </div>
            <div class="text-container">
                <p>Precipitation and snowmelt improve quickflow, help fill streams, and can recharge the water available to plants in the ground. Soil moisture provides water for plants in the root zone and recycling water back to the atmosphere through plant transpiration and evaporation from bare soils (Legates et al., 2011). During summer months in the Souris-Red-Rainy, Texas, Southern High Plains, and Southwest Desert hydrologic regions soil moisture volumes are very low, indicating that the precipitation that falls during these times is directly lost to streamflow and/or plants and relatively little is partitioned to groundwater storage. 
                </p>
                <h2>Water stress in the U.S.</h2>
                <p>The combination of low precipitation and little input to soil moisture, snow, or lakes and reservoirs are conditions that can cause water stress. Areas in the U.S. with water supply issues include the Southern, and Central High Plains, Texas, and the Southwest Desert regions. In many of these regions, groundwater supply fills this need, but an over reliance on slowly recharged groundwater resources has resulted in substantially lowered water levels.</p><br>

                
                <p>Extremely dry conditions were observed in greater than 25 percent of the Southeast aggregated region in 2011. In 2012, greater than 75 percent of the High Plains and greater than 60 percent of the Northeast-Midwest aggregated regions suffered extremely dry conditions due to anomalously low rainfall totals in spring and summer. These extremely dry conditions were associated with the most severe and widespread drought in the period of analysis and one of the most extreme droughts since the 1930s Dust Bowl (Hoerling and others, 2014; Bell and others, 2015). Learn more about this recent drought at <a href="https://labs.waterdata.usgs.gov/visualizations/drought-timeline/index.html#/" target="_blank">Five droughts that changed history</a></p>
            </div>

            <References></References>
        </div>
        <PageCarousel></PageCarousel>
    </section>
</template>

<script setup>
import { onMounted } from 'vue';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import References from '../components/References.vue';


</script>

<style scoped>

</style>
