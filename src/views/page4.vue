<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <button id="image-toggle" class="toggle-button">View Dry Areas Only</button>

        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat.</p>

        <div class="viz-container">
            <img 
                    id="first-image" 
                    class="viz-placeholder" 
                    :src="photoAll" 
                    alt="xxx"
                >
        </div>
        <PageCarousel></PageCarousel>
    </section>
</template>

<script setup>
import { onMounted } from 'vue';
    import PageCarousel from '../components/PageCarousel.vue';
    import KeyMessages from '../components/KeyMessages.vue';
    import photoAll from "@/assets/images/k04_sui_svi_map.png";
    import photoDry from "@/assets/images/k04_sui_svi_dry_map.png";

onMounted(() => {

    let firstImg = document.getElementById("first-image");
    let imageToggle = document.getElementById("image-toggle");


    function toggleImg() {
        if(firstImg.getAttribute('src') === photoAll) {
            firstImg.setAttribute('src', photoDry);
            imageToggle.textContent = "View All Areas";
        }
        else {
            firstImg.setAttribute('src', photoAll);
            imageToggle.textContent = "View Dry Areas Only";
        }
    }

    imageToggle.addEventListener("click", toggleImg)
}); 
</script>

<style scoped>

</style>