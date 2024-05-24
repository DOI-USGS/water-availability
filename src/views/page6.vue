<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="viz-container">
            <button id="image-toggle" @mouseover="">Toggle Image</button>
            <div class="image-container">
                <img id="first-image" class="viz-placeholder visible" src="@/assets/images/k06_wq_by_threat_all.png" alt="xxx">
                <img id="second-image" class="viz-placeholder hidden" src="@/assets/images/k06_wq_by_threat_all_noUnimpaired.png" alt="xxx">
            </div>            
        </div>
        <PageCarousel></PageCarousel>
    </section>
</template>

<script setup>
import { onMounted } from 'vue';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';


onMounted(() => {
    let firstImg = document.getElementById("first-image");
    let secondImg = document.getElementById("second-image");
    let imageToggle = document.getElementById("image-toggle");

  function toggleImg() {
    if(secondImg.getAttribute('class') === "viz-placeholder hidden") {
        secondImg.setAttribute('class', "viz-placeholder visible");
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
    position:relative;
    width:100%;
    top: 0;
    left: 0;
}
#first-image{
    position: relative;
    top: 0;
    left: 0;
    z-index: 0;
}
#second-image{
    position: absolute;
    top: 0;
    left: 0;
    z-index: 4;
}

.toggle-button{
    background-color: #eee;
  color: #fff;
  cursor:pointer;
  padding: 18px;
  width: 100%;
  border: none;
  text-align: left;
  outline: none; 
}
.toggle-button:hover{
    background-color: green;
    color:red;
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