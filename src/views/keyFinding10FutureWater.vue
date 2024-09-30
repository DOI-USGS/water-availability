<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat.</p>
            </div>
            <div class="viz-container">
                <img class="viz-placeholder" src="@/assets/images/k02_future.png">
            </div>
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