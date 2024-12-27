<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
          <div class="text-container">
            <p>The conditions that limit water availability often occur together. For example, areas with limited water supply can be more vulnerable to water quality issues and alterations to ecological flow. The relative impact of these factors varies from region to region, and regions that have water limitation arising from more than one indicator may pose the greatest challenges to resource managers. The four indicators of integrated water availablity were the amount of water (water quanity), the quality of surface and groundwater, and alterations to natural flow (ecoflows). Within each indicator, high limitation indicates areas where water quality or quantity conditions exceed the requirements, or sensitivity, for a particular use.<span v-for="reference in theseReferences.filter(item => item.refID === 'Stets2025')" :key="reference.refID" class="tooltip"> <sup class="in-text-number">{{ reference.referenceNumber }} </sup> <span class="tooltiptext"> {{ reference.refID }}</span></span></p>
            <br>
            <h3>Water availability is limited by water quantity</h3>
            <p>The overall balance between water supply and use is a primary consideration in water availability studies. Globally, the factors affecting human water security are highly correlated; the infrastructure that allows elevated water use also promotes water-quality degradation and decreases biotic integrity. (vorosmorty xxx) Areas of the country with high water availability stress from water limitation are primarily located in the central U.S. (lin park xxx)</p>
          </div>
          <div class="viz-container">
            <img class="viz-portrait" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/02_water_avail_wa_sui.png" />
          </div>
          <div class="text-container">
            <h3>Water availability is limited by surface water quality</h3>
            <p>Surface water quality can be degraded by nutrients, sediment, temperature, pathogens, salinity, and pesticides. Sources of water quality contaminants include agriculture, wastewater, air pollution, other human sources such as mining and land-use change, and natural sources such as springs and streamflow. Areas of the country that strongly indicate surface water quality issues include the High Plains, Souris-Red-Rainy, and the Midwest regions, largely due to the application of fertilizer and manure for agriculture. (erickson2025 xxx)</p>
          </div>
          <div class="viz-container">
            <img class="viz-portrait" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/02_water_avail_wa_sw_wq.png" />
          </div>
          <div class="text-container">
            <h3>Water availability is limited by groundwater quality</h3>
            <p>Groundwater-derived drinking water can be affected by high concentrations of constituents from geologic sources, including arsenic, manganese, strontium, radionuclides, fluoride, and lithium, as well as salinity and nitrogen. Mixtures of multiple groundwater contaminants can also have compounding effects, because different users may have elevated sensitivity when exposed to multiple water-quality issues at once. ("Kaushal2018", "Waite2019", "Waite2021" xxx) Threats to human health, corrosion of infrastructure, reduced crop yields, poor taste, impeded navigation, and economic impacts can all result from poor water quality (erickson2025 xxx)</p>
          </div>
          <div class="viz-container">
            <img class="viz-portrait" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/02_water_avail_wa_gw_wq.png" />
          </div>
          <div class="text-container">
            <h3>Water availability for ecosystems is limited by altered natural flows</h3>
            <p>Humans alter the natural flow of water by building water management structures, such as reservoirs, impoundments, and diversions, and covering land with impervious surfaces. We create water-management structures to improve quality of life by creating hydroelectric power, controlling flood risk, capturing and distributing drinking water, and irrigating crops. These structures can affect the flow regime through water storage and releases, potentially altering the timing, seasonality, frequency, and rate of change of flows ("Kennedy2016", "Eng2019", "Moreira2019" xxx), even if total flow volume remains equivalent. Anthropogenic land cover, such as urban areas and impervious surfaces, can also affect flow attributes by increasing the rate of runoff, resulting in greater high-flow magnitude and frequency, while decreasing flow durations.["Eng2019"]</p>
          </div>
          <div class="viz-container">
            <img class="viz-portrait" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/02_water_avail_wa_ecoflow.png" />
          </div>
          <Methods></Methods>
          <References :theseReferences="referenceList"></References>
        </div>
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>
</template>

<script setup>
import {inject, ref} from 'vue';
import { useRoute } from 'vue-router';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import references from './../assets/text/references.js';
import References from '../components/References.vue';
import SubPages from '../components/SubPages';
import { isMobile } from 'mobile-device-detect';

const route = useRoute();
const featureToggles = inject('featureToggles');


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

</script>

<style scoped>


</style>