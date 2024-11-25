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
                <button id="image-toggle" class="toggle-button">View areas of high water stress</button>
            </div>
            <div class="viz-container">
                <img 
                        id="first-image" 
                        class="viz-placeholder" 
                        :src="photoAll" 
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
import { onMounted, inject } from 'vue';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import References from '../components/References.vue';
import photoAll from "../assets/images/R/03_sui_svi_map.png";
import photoDry from "../assets/images/R/03_sui_svi_dry_map.png";


const featureToggles = inject('featureToggles');

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