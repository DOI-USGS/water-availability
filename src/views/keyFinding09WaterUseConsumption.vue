<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <p>Not all water withdrawn for human water use returns to the local environment. Some water is lost as consumptive use because it is evaporated, transpired, incorporated into products or crops, consumed by humans or livestock, or otherwise made unavailable for immediate use. Between 2010 and 2020, approximately 83,000 mgd (37% of total withdrawals from freshwater) were lost as consumptive water use in the lower 48 states across all water use categories. Crop irrigation accounted for 90% of the consumptive losses, whereas thermoelectric and public supply accounted for only 3% and 7%, respectively (Medalie et al., 2025).</p>
            </div>
            <div class="text-container">
                <h3>About 72% of water withdrawn for irrigation is consumed rather than returned to the local environment.</h3>
                <img class="viz-portrait" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/09_cu_irrigation.png">
                <p>For irrigation, the proportion of the water returned to the local environment is influenced primarily by climate and the ability of the irrigation system to meet crop needs (efficiency), varies greatly across the country. In general, higher proportions of water are consumed for crop irrigation in the eastern U.S. than the western U.S. During drought, crop needs for irrigation are greater, and more water is lost as consumptive use to evapotranspiration, even though the footprint of irrigated crops typically shrinks (Martin et al., 2023; Haynes et al., 2024). Some areas without sufficient local resources use water for crop irrigation that is transported from other areas with abundant water resources, changing the natural water availability in both the sending and receiving areas. Transfers of water for crop irrigation are particularly common in the western U.S.</p>
            </div>
            <div class="text-container">
                <h3>About 12% of water withdrawn for public supply is consumed rather than returned to the local environment.</h3>
                <img class="viz-portrait" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/09_cu_public_supply.png">
                <p>Most water used for public supply is returned to the local environment by returning water from wastewater treatment plants or through sewer systems. On a national basis, about 88% of the water withdrawn for public supply is returned to the local environment. Water that is not returned includes water consumed by humans and animals, water incorporated into products or crops, water evaporated from the landscape, and water transpired from plants.  Some areas without sufficient local resources use water for public supply that is transported from other areas with more abundant water resources, changing the natural water availability in both the sending and receiving areas. Movement of water for public supply is typically from rural to urban areas.</p>
            </div>

            <div class="text-container">
                <h3>About 4% of water withdrawn for thermoelectric power generation is consumed rather than returned to the local environment.</h3>
                <img class="viz-portrait" src="https://labs.waterdata.usgs.gov/visualizations/images/water-availability/09_cu_thermoelectric.png">
                <p>Overall thermoelectric-power water use is characterized by large withdrawals and relatively low consumptive use (Diehl and Harris, 2014; Harris and Diehl, 2019). However, volumes of water withdrawn and consumed for thermoelectric power at individual facilities vary tremendously and are entirely influenced by the type of cooling system used by the facility.  One broad type of cooling system is once-through, where a large volume of water is withdrawn and a relatively small amount is consumed through evaporation. The other broad type of system recirculates water for multiple cooling cycles, resulting in much smaller withdrawals than once-through systems.  On the other hand, recirculating cooling systems consume a larger percentage, up to 70%, of the water through evaporation  (Harris and Diehl, 2019). Between 2010 to 2020, many plants shifted from once-through cooling systems towards recirculating cooling systems.</p>
            </div>
            <Methods></Methods>
            <References :theseReferences="referenceList"></References>
        </div>
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>
</template>

<script setup>
import { ref, inject, computed } from 'vue';
import { useRoute } from 'vue-router';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import references from './../assets/text/references.js';
import References from '../components/References.vue';
import SubPages from '../components/SubPages';
import { isMobile } from 'mobile-device-detect';

const featureToggles = inject('featureToggles');

const route = useRoute();
const path = computed(() => route.path)

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