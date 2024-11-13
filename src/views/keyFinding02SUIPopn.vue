<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
          <div class="viz-container">
            <img class="viz-portrait" src="../assets/images/R/02_sui_popn_CONUS.png">
          </div>
          <div class="text-container">
            <p>During drought, water stress is reduced by switching sources or using water stored in local reservoirs. In the Western United States, <a href="https://labs.waterdata.usgs.gov/visualizations/snow-to-flow/index.html#/" target="_blank">snowpack acts like a water tower,</a> holding frozen water during colder months that can help sustain ecosystems and human populations later in the year (Dettinger, 2005). In other areas, water may be transported in to supplement local water supplies. These types of inter-basin transfers may be used seasonally or year-round and are important in for meeting the water demands for people living in high water stress areas. Public water utilities in particular often rely on transferring water from other more pristine watersheds to provide high-quality water for their customers (Liu et al., 2022). However, relying on other watersheds can leave the receiving basin vulnerable in situations where the donor basin also has a water shortage.  </p>
          </div>

          <div class="text-container">
            <p>High water stress is often due to multiple stressors. When there is high water demand driven by human activites paired with limited supply, this often co-occures with elevated water stress from other factors like water and groundwater quality issues, water imbalance, or by alterations to ecological flow.</p>
          </div>
          <div class="viz-container">
            <img class="viz-landscape" src="../assets/images/manual/02_stressType_maps.png">
          </div>
          <Methods></Methods>
          <References></References>
        </div>
        <PageCarousel></PageCarousel>
    </section>
</template>

<script setup>
  import PageCarousel from '../components/PageCarousel.vue';
  import KeyMessages from '../components/KeyMessages.vue';
  import Methods from '../components/Methods.vue';
  import References from "../components/References.vue";


</script>

<style scoped>

</style>