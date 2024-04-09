<template>
    <section class="main-container">
        <div class="wavy-container">
            <div class="key-message-container">
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor</p>
                <h2>Key Message #7</h2>
            </div>
        </div>
        <div class="viz-container">
            Interactive viz goes here
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