<template>
    <section class="main-container">
        PAGE 3<br>
        <router-link to="/">Home</router-link>
        <div class="viz-container">

        </div>
        <PageCarousel></PageCarousel>
    </section>
</template>

<script>
import PageCarousel from '../components/PageCarousel.vue';
export default {
    components: {
        PageCarousel
    }
}
</script>

<style scoped>

</style>