<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat.</p>
            </div>
            <div class="button-container">
                <button id="image-toggle" class="toggle-button">Add lag</button>
            </div>
            <div class="viz-container">
                <img 
                    id="first-image" 
                    class="viz-placeholder" 
                    :src="photoNoLag" 
                    alt="xxx"
                >
            </div>
        </div>
        <PageCarousel></PageCarousel>
    </section>
</template>

<script setup>
import { onMounted } from 'vue';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import photoNoLag from "@/assets/images/k09_precip_sf.png";
import photoLag from "@/assets/images/k09_precip_sf_lag.png";



onMounted(() => {

let firstImg = document.getElementById("first-image");
let imageToggle = document.getElementById("image-toggle");


function toggleImg() {
if(firstImg.getAttribute('src') === photoNoLag) {
    firstImg.setAttribute('src', photoLag);
    imageToggle.textContent = "Remove lag";
}
else {
    firstImg.setAttribute('src', photoNoLag);
    imageToggle.textContent = "Add lag"
}
}

imageToggle.addEventListener("click", toggleImg)
}); 
</script>

<style scoped>

</style>