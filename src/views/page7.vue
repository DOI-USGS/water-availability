<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="viz-container">
            <img class="viz-placeholder"
            src="@/assets/images/k07_wu_all.png"
            >
        </div>
        <PageCarousel></PageCarousel>
    </section>
</template>

<script>
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue'
export default {
    components: {
        PageCarousel,
        KeyMessages
    }
}
</script>

<style scoped>

</style>