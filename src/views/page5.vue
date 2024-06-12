<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
            <button id="image-toggle" class="toggle-button">Click for Total Phosphorus</button>
        <div class="viz-container">
                <img 
                    id="first-image" 
                    class="viz-placeholder" 
                    :src="photoTN" 
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
import photoTN from "@/assets/images/k05_wq_tn_source.png";
import photoTP from "@/assets/images/k05_wq_tp_source.png";

onMounted(() => {

    let firstImg = document.getElementById("first-image");
    let imageToggle = document.getElementById("image-toggle");


    function toggleImg() {
        if(firstImg.getAttribute('src') === photoTN) {
            firstImg.setAttribute('src', photoTP);
            imageToggle.textContent = "Click for Total Nitrogen";
        }
        else {
            firstImg.setAttribute('src', photoTN);
            imageToggle.textContent = "Click for Total Phosphorus";
        }
    }

    imageToggle.addEventListener("click", toggleImg)
}); 
</script>

<style scoped>

</style>