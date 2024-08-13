<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <button id="image-toggle" class="toggle-button">Add lag</button>
        <div class="viz-container">
                <img 
                    id="first-image" 
                    class="viz-placeholder" 
                    :src="photoNoLag" 
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