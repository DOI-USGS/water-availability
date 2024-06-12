<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        
        <div class="viz-container">
        <AggReg class="agg-reg-svg"></AggReg>
        <h3 class="dumbbell-header">Public Supply Sourced From:</h3>
        <div class="axis-labels">
            <h3 class="groundwater">Groundwater</h3>
            <h3 class="surface-water"> Surface Water</h3>
        </div>

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
.agg-reg-svg {
    width: 20%;
    height: auto;
    margin-right: 20px;
}
.axis-labels {
    transform: rotate(-90deg);
    width: 35px;
    white-space: nowrap;
    margin-bottom: -270px;
    margin-right: -15px;
}

.dumbbell-header {
    transform: rotate(-90deg);
    width: 35px;
    white-space: nowrap;
    margin-bottom: -260px;
    color: #2d2b2a;
    font-size: 1.2em;
}
.groundwater {
    display: inline;
    margin-right: 15px;
    color: #e9830d;
    font-size: 1.2em;
}
.surface-water {
    display: inline;
    margin-left: 15px;
    color: #2b5d69;
    font-size: 1.2em;
}

img {
    width: 35%
}

@media only screen and (max-width: 768px) {
    .viz-container {
        flex-direction: column;
    }
    .dumbbell-header {
        /* display: none; */
        transform: rotate(0deg);
        margin: 0px;
        text-align: center; /* Center text */
        font-size: 0.9em;
        margin-left: -190px;

    }
    .axis-labels {
        /* display: none */
        transform: rotate(0deg);
        margin: 0px;
        margin-left: -210px;
    }

    .groundwater {
    font-size: 0.9em;
    }   
    .surface-water {
    display: inline;
    margin-left: 15px;
    color: #2b5d69;
    font-size: 0.9em;
    }
    .agg-reg-svg {
    width: 40%;
    height: auto;
    margin-right: 0px;
    margin-bottom: -80px;
    margin-top: -50px;
    }

    img {
    width: 50%;
    margin-top: 20px;
    }

}

</style>