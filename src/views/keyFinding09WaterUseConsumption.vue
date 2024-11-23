<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <p>The proportion of water that is withdrawn from groundwater or surface water for human use but that is then evaporated, transpired, incorporated into products or crops, consumed by humans or livestock, or otherwise removed from the immediate environment is called consumptive use. The proportion of water withdrawals that is consumed rather than returned to the local environment varies by use type.</p>
            </div>
            <div class="viz-container">
                <img class="viz-placeholder" src="../assets/images/manual/09_cu_overview.png">
            </div>
            <div class="text-container">
                <h2>Public supply</h2>
                <p>Most water used for public supply is returned to the local environment. On a national basis, about 85% of the water withdrawn for public supply is returned to the local environment. Water that is not returned includes water consumed by humans and animals, water evaporated from the landscape, and water transpired from plants. In some areas, water is transferred out of the watershed in which it was withdrawn rather than consumed or returned to local water bodies.</p>
            </div>
            <div class="viz-container">
                <img class="viz-portrait" src="../assets/images/manual/09_cu_public_supply.png">
            </div>
            <div class="text-container">
                <h2>Irrigation</h2>
                <p>The proportion of water withdrawn for irrigation that was consumed, rather than returned, is on average about 70%. This proportion varies from 59-84% across the country, with largest percents in the Northeast through Midwest aggregated hydrologic regions and smallest percents in the Western aggregated hydrologic regions. During drought, even with less irrigated land, crop needs for irrigation are greater and more water is lost as consumptive use to evapotranspiration (Martin and others, 2023; Haynes and others, 2024).</p>
            </div>
            <div class="viz-container">
                <img class="viz-portrait" src="../assets/images/manual/09_cu_irrigation.png">
            </div>
            <div class="text-container">
                <h2>Thermoelectric power</h2>
                <p>Thermoelectric-power water use is characterized by large withdrawals and relatively low consumptive use (Diehl and Harris, 2014; Harris and Diehl, 2019). Two broad types of cooling systems are once-through and recirculating. Once-through cooling systems withdraw large volumes of water that circulate through powerplant condensers to condense the steam used to generate electricity. Heated water is discharged back to the source; a relatively small amount of that water is consumed through evaporation. Recirculating cooling systems reuse water within the cooling system multiple times and consequently withdraw less from a water source but consume, through evaporation, a larger percentage of the water withdrawn as compared with once-through cooling systems. Consumptive-use rates in plants with recirculating systems can be as much as or greater than 70 percent of withdrawals (Harris and Diehl, 2019). During 2010-20, an overall shift has occurred in powerplant infrastructure from once-through cooling systems towards recirculating cooling systems, and as a consequence, withdrawals for thermoelectric power have decreased while the relative amount of consumptive use to withdrawals has increased (Harris and others, in prep.).</p>
            </div>
            <div class="viz-container">
                <img class="viz-portrait" src="../assets/images/manual/09_cu_thermoelectric.png">
            </div>
            <Methods></Methods>
            <References></References>
        </div>
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="showCarousel"></PageCarousel>
    </section>
</template>

<script setup>
    import PageCarousel from '../components/PageCarousel.vue';
    import KeyMessages from '../components/KeyMessages.vue';
    import Methods from '../components/Methods.vue';
    import References from '../components/References.vue';

</script>

<style scoped>

</style>