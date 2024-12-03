<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <p>Water stress disproportionately affects socially vulnerable populations in the U.S., creating problems for equitable access to clean water. Most Americans experience regionally low water stress, which means that the amount of clean water available is sufficient to meet the needs of humans and the environment. It also means that within areas of low water stress, there is a wide range of <a href="https://labs.waterdata.usgs.gov/visualizations/vulnerability-indicators/index.html#/en" target="_blank">social vulnerability</a>, or conditions in which societal factors shape exposure to hazards, susceptibility to suffer harm, and ability to cope and recover from losses (Drakes et al., 2024).</p>
                <h2>Social vulnerability is disproportionately high in areas of high water stress</h2>
                <p>When viewing only the driest ares, the map shows almost exclusively dark red patches, meaning that most areas with high water stress occur where people are socially vulnerable. Water stress disproportionately affects socially vulnerable populations in the U.S., creating problems for equitable access to clean water. </p>
            </div>
            <div class="button-container">
                <button id="image-toggle" class="toggle-button" @click="showStress">View areas of high water stress</button>
            </div>
            <div class="viz-container">
                <img 
                        id="first-image" 
                        class="viz-placeholder" 
                        :src="imgSrc" 
                        alt="xxx"
                    >
        </div>
        <Methods></Methods>
        <References></References>
        </div>
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>
</template>

<script setup>
import { onMounted, inject, ref } from 'vue';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import References from '../components/References.vue';
//import photoAll from "https://labs.waterdata.usgs.gov/visualizations/images/water-availability/03_sui_svi_map.png";
//import photoDry from "https://labs.waterdata.usgs.gov/visualizations/images/water-availability/03_sui_svi_dry_map.png";

// global variables
const baseURL = "https://labs.waterdata.usgs.gov/visualizations/images/water-availability/";
const defaultImageID = "03_sui_svi_map";
let imgSrc = ref(getImgURL(defaultImageID));

const featureToggles = inject('featureToggles');


// functions called here
onMounted(() => {
    let imageToggle = document.getElementById("image-toggle");

    imageToggle.addEventListener("click", toggleImg)
});

function getImgURL(id) {
  return new URL(`${baseURL}${id}.png`);
}

function showStress() {
    if(imgSrc.value === 'https://labs.waterdata.usgs.gov/visualizations/images/water-availability/03_sui_svi_map.png') {
        imgSrc = getImgURL('03_sui_svi_dry_map');
        console.log(imgSrc.value)
    } else {
        imgSrc = getImgURL('03_sui_svi_map');
        console.log(imgSrc)
    }
}


function toggleImg() {

    if(imgSrc.value === getImgURL('03_sui_svi_map')) {
        imgSrc = ref(getImgURL('03_sui_svi_dry_map'));
        console.log(imgSrc.value)
        //imageToggle.textContent = "View All Areas";
    }
    else {
        imgSrc.value = getImgURL('03_sui_svi_map');
        //imageToggle.textContent = "View Dry Areas Only";
    }
}


</script>

<style scoped>

</style>