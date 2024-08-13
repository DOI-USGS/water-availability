<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <button id="image-toggle" class="toggle-button">Click to change view</button>
        <div class="viz-container">
                <img 
                    id="first-image" 
                    class="viz-placeholder" 
                    :src="photoProportion" 
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