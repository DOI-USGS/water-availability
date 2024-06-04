<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <button id="image-toggle" class="toggle-button">Click to remove unimpaired</button>
        <div class="viz-container">
                <img 
                    id="first-image" 
                    class="viz-placeholder" 
                    :src="photo1" 
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
import photo1 from "@/assets/images/k06_wq_by_threat_all.png";
import photo2 from "@/assets/images/k06_wq_by_threat_all_noUnimpaired.png";



onMounted(() => {

    let firstImg = document.getElementById("first-image");
    let imageToggle = document.getElementById("image-toggle");


  function toggleImg() {
    if(firstImg.getAttribute('src') === photo1) {
        firstImg.setAttribute('src', photo2);
        imageToggle.textContent = "Click to add unimpaired";
    }
    else {
        firstImg.setAttribute('src', photo1);
        imageToggle.textContent = "Click to remove unimpaired";
    }
  }

  imageToggle.addEventListener("click", toggleImg)
}); 

</script>

<style scoped>





</style>