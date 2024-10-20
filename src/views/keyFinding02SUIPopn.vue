<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
          <div class="text-container">
            <p>In many areas of the U.S., short-term water stress is reduced by water storage in local reservoirs or by switching sources during droughts. In the Western United States, snowpack serves as an important water source, which can help sustain ecosystems and human populations during dry summer and autumn seasons (Dettinger, 2005). In other areas, water is sometimes withdrawn from one area or watershed and transported to others. These types of inter-basin transfers can be used to supplement local water supplies either seasonally or year-round and are important in for meeting the water demands for people living in high water stress areas. Public water utilities in particular often rely on transferring water from other more pristine watersheds to provide high-quality water for their customers (Liu et al., 2022). However, relying on other watersheds can leave the receiving basin vulnerable in situations where the donor basin also has a water shortage. </p>
          </div>
          <div class="viz-container">
            <img class="viz-portrait" src="../../public/images/k02_sui_popn_CONUS.png">
          </div>
          <div class="text-container">
            <p>Understanding limitations to water availability are evident when multiple types of stresses are examined together. Regions stressed by multiple factors, such as surface water and groundwater quality issues, water imbalance, or by alterations to ecological flow, are at additional risk for addressing issues of water supply in the future. None of the hydrologic regions in the U.S. have very low stress in all four categories. The ability to better describe the specific ways in which water-availability limitations interact is vital and presents an important path forward in improving future water-availability assessments. Nevertheless, our findings emphasize that high water demand for human activities combined with limited supply often co-occurs with elevated water stress from other factors.</p>
          </div>
          <div class="viz-container">
            <img class="viz-portrait" src="../../public/images/kf2_stressType_maps.png">
          </div>
          <References></References>
        </div>
        <PageCarousel></PageCarousel>
    </section>
</template>

<script setup>
  import PageCarousel from '../components/PageCarousel.vue';
  import KeyMessages from '../components/KeyMessages.vue';
  import References from "../components/References.vue"


</script>

<style scoped>

</style>