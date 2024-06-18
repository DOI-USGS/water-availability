<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        
        <div class="viz-container">
          <AggReg class="agg-reg-svg"></AggReg>
          <img
              id="dumbbells"
              :src="imgSrc"
              alt=""
          >    
        </div>
        <button id="image-toggle" class="toggle-button">Switch to Irrigation</button>
        <div class="viz-container">
                <img 
                    id="first-image" 
                    class="viz-placeholder" 
                    :src="photoPublic" 
                    alt="xxx"
                >
         </div>
        <PageCarousel></PageCarousel>
    </section>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import * as d3Base from 'd3';
import AggReg from "@/assets/svgs/AggReg.svg";
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import photoPublic from "@/assets/images/k08_ps_wheatfield_CONUS.png";
import photoIrrigation from "@/assets/images/k08_ir_wheatfield_CONUS.png";

const imgSrc = ref('@/assets/images/ws_ps_dumbbell_centered_CONUS.png');

const imgSrc = ref('@/assets/images/ws_ps_dumbbell_centered_CONUS.png');

const setDefaultImgSrc = () => {
  import(`@/assets/images/k08_ws_ps_dumbbell_centered_CONUS.png`).then(img => {
    imgSrc.value = img.default;
  });
};

const addInteractions = () => {
  const mapSVG = d3Base.select('.agg-reg-svg');
  mapSVG.selectAll('.AggReg_nam_nospace')
    .on("mouseover", mouseoverMap)
    .on("mouseout", mouseoutMap);
};

const mouseoverMap = (event) => {
  const regionID = event.target.id;
  d3Base.select('.agg-reg-svg').selectAll(`#${regionID}`).style("fill", "#5e7789");
  const formattedRegionID = regionID.replace(/_/g, ' ');
  import(`@/assets/images/k08_ws_ps_dumbbell_centered_${formattedRegionID}.png`).then(img => {
    imgSrc.value = img.default;
  });
};

const mouseoutMap = (event) => {
  const regionID = event.target.id;
  d3Base.select('.agg-reg-svg').selectAll(`#${regionID}`).style("fill", "#d1cdc0");
  import(`@/assets/images/k08_ws_ps_dumbbell_centered_CONUS.png`).then(img => {
    imgSrc.value = img.default;
  });
};

onMounted(() => {
  setDefaultImgSrc();
  addInteractions();

  const firstImg = document.getElementById("first-image");
  const imageToggle = document.getElementById("image-toggle");

  const toggleImg = () => {
    if (firstImg.getAttribute('src') === photoPublic) {
      firstImg.setAttribute('src', photoIrrigation);
      imageToggle.textContent = "Switch to Public Supply";
    } else {
      firstImg.setAttribute('src', photoPublic);
      imageToggle.textContent = "Switch to Irrigation";
    }
  };

  imageToggle.addEventListener("click", toggleImg);
});
</script>


<style scoped>



img {
    width: 35%
}

@media only screen and (max-width: 768px) {


    img {
    width: 50%;
    margin-top: 20px;
    }

}

</style>