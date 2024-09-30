<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat.</p>
            </div>
            <div class="button-container">
                <button id="image-toggle" class="toggle-button">Click to change view</button>
            </div>
            <div class="viz-container">
                    <img 
                        id="first-image" 
                        class="viz-placeholder" 
                        :src="photoProportion" 
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
import photoProportion from "@/assets/images/k06_wq_by_use.png";
import photoMiles from "@/assets/images/k06_wq_by_use_noImpaired.png";



onMounted(() => {

    let firstImg = document.getElementById("first-image");
    let imageToggle = document.getElementById("image-toggle");


  function toggleImg() {
    if(firstImg.getAttribute('src') === photoProportion) {
        firstImg.setAttribute('src', photoMiles);
        imageToggle.textContent = "Click to change view";
    }
    else {
        firstImg.setAttribute('src', photoProportion);
        imageToggle.textContent = "Click to change view";
    }
  }

  imageToggle.addEventListener("click", toggleImg)
}); 

</script>

<style scoped>





</style>