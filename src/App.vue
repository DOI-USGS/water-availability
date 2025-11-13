<template>
  <div>
    <WindowSize v-if="typeOfEnv === '-test build-'" />
    <HeaderUSWDSBanner v-if="typeOfEnv !== '-test build-'" />
    <HeaderUSGS />
    <!-- <ShutdownBanner /> -->
    <!-- Render the WorkInProgressWarning component only if typeOfEnv is not empty -->
    <WorkInProgressWarning
      v-if="typeOfEnv !== ''"
    />
    <RouterView />
    <PreFooterCodeLinks />
    <FooterUSGS />
  </div>
</template>

<script setup>
  import { reactive, provide, onMounted } from "vue";
  import { RouterView } from 'vue-router'
  import WindowSize from "./components/WindowSize.vue";
  import HeaderUSWDSBanner from "./components/HeaderUSWDSBanner.vue";
  import HeaderUSGS from './components/HeaderUSGS.vue';
  // import ShutdownBanner from './components/ShutdownBanner.vue';
  import WorkInProgressWarning from "./components/WorkInProgressWarning.vue";
  import FooterUSGS from './components/FooterUSGS.vue';
  import { useWindowSizeStore } from './stores/WindowSizeStore';
  import PreFooterCodeLinks from "@/components/PreFooterCodeLinks.vue";

  const windowSizeStore = useWindowSizeStore();
  const typeOfEnv = import.meta.env.VITE_APP_TIER;
  const animateTime = 400;

  // define feature toggles
  // reactive feature toggles
  const previewSiteLogic = false; // change this one setting to toggle preview site on and off
  const featureToggles = reactive({
    keyFindingToggles: {
      keyFinding01: true, // always true
      keyFinding02: previewSiteLogic ? false : true,
      keyFinding03: previewSiteLogic ? false : true,
      keyFinding04: previewSiteLogic ? false : true,
      keyFinding05: previewSiteLogic ? false : true,
      keyFinding06: previewSiteLogic ? false : true,
      keyFinding07: previewSiteLogic ? false : true,
      keyFinding08: previewSiteLogic ? false : true
    },
    showReportLinks: previewSiteLogic ? false : true, // buttons that say "read the report" and "download the data"
    showPageCarousel: previewSiteLogic ? false : true, // page carousel at bottom of key finding pages
    showAlternativeWarning: true, // alternative warning message
  });


  // provide feature toggles to the entire app
  provide('featureToggles', featureToggles);
  provide('animateTime', animateTime);


  // Declare behavior on mounted
  // functions called here
  onMounted(() => {
    // Add window size tracking by adding a listener
    window.addEventListener('resize', handleResize);
    handleResize();
  });

  // Functions
  function handleResize() {
    // store the window size values in the Pinia state
    windowSizeStore.windowWidth = window.innerWidth;
    windowSizeStore.windowHeight = window.innerHeight;
  }
</script>

<style>
#window-size-component {
  width: 200px;
}
</style>