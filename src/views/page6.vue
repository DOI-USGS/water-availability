<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <button id="image-toggle" class="toggle-button">Toggle Image</button>
        <div class="viz-container">
            <div class="image-container">
                <img 
                    id="first-image" 
                    class="viz-placeholder visible" 
                    v-for="imgSrc in photoSrc"
                    :src="imgSrc" 
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
import photo1 from "@/assets/images/k06_wq_by_threat_all.png";
import photo2 from "@/assets/images/k06_wq_by_threat_all_noUnimpaired.png";



const photoSrc = [photo1];


onMounted(() => {



    let firstImg = document.getElementById("first-image");
    //let secondImg = document.getElementById("second-image");
    let imageToggle = document.getElementById("image-toggle");

    //let imgSrc = photo1;

  function toggleImg() {
    if(secondImg.getAttribute('class') === "viz-placeholder hidden") {
        secondImg.setAttribute('class', "viz-placeholder visible");
        firstImg.setAttribute('src', firstImg);
        
        console.log("test");
    }
    else {
        console.log("non");
        secondImg.setAttribute('class', "viz-placeholder hidden");
    }
  }

  imageToggle.addEventListener("click", toggleImg)
}); 

</script>

<style scoped>


.image-container{
  position: relative;
  width: 100%;
  top: 0;
  left: 0;
    display: flex;
    align-items: center;
    justify-content: center;
}
#first-image{
    position: relative;
    top: 0;
    left: 0;
    z-index: -2;
}
#second-image{
    position: absolute;
    top: 0;
    left: 0;
    z-index: -1;
}

.toggle-button{
    background-color: blue;
  color: #fff;
  cursor:pointer;
  padding: 18px;
  width: 100px;
  border: none;
  text-align: left;
  outline: none; 
}
.toggle-button:hover{
    background-color: black;
    color: white;
}

.hidden {
  visibility: hidden;
  display: none;
  opacity: 0;
  transition: visibility 0s 0.5s, opacity 0.5s linear;
}
.visible {
  visibility: visible;
  display: inline;
  opacity: 1;
  transition: fade 0.5s linear;
}
</style>