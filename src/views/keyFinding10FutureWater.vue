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
            <Methods></Methods>
            <References></References>
        </div>
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>
</template>

<script setup>
import { inject } from 'vue';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import References from '../components/References.vue';

const featureToggles = inject('featureToggles');
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
</style>