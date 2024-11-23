<template>
  <div>
    <WindowSize v-if="typeOfEnv === '-test build-'" />
    <HeaderUSWDSBanner v-if="typeOfEnv !== '-test build-'" />
    <HeaderUSGS />
    <!-- Render the WorkInProgressWarning component only if typeOfEnv is not empty -->
    <WorkInProgressWarning
      v-if="typeOfEnv !== ''"
    />
    <RouterView />
    <FooterUSGS />
  </div>
</template>

<script setup>
  import { reactive, provide, onMounted } from "vue";
  import { RouterView } from 'vue-router'
  import WindowSize from "./components/WindowSize.vue";
  import HeaderUSWDSBanner from "./components/HeaderUSWDSBanner.vue";
  import HeaderUSGS from './components/HeaderUSGS.vue';
  import WorkInProgressWarning from "./components/WorkInProgressWarning.vue";
  import FooterUSGS from './components/FooterUSGS.vue';
  import { useWindowSizeStore } from './stores/WindowSizeStore';

  const windowSizeStore = useWindowSizeStore();
  const typeOfEnv = import.meta.env.VITE_APP_TIER;

  // define feature toggles
  const featureToggles = reactive({
    showAlternativeWarning: true, // toggle to control alternative warning text
  });

  // provide feature toggles to the entire app
  provide('featureToggles', featureToggles);


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

