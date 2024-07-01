<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="viz-container">
          <img class="viz-placeholder"
            src="@/assets/images/k03_sui_popn_CONUS.png"
          >
        </div>
        <PageCarousel></PageCarousel>
    </section>
</template>

<script setup>
    import PageCarousel from '../components/PageCarousel.vue';
    import KeyMessages from '../components/KeyMessages.vue';

</script>

<style scoped>

</style>