<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
          <div class="text-container">
                <p>The spatial patterns of the relative proportion of water use for public supply (PS), irrigation (IR), and thermoelectric power (TE) show that these categories vary in their importance regionally. Crop irrigation is the largest category of use in the western U.S., while thermoelectric power is the largest category of use in the central and eastern U.S. Public supply accounts for nearly one-half of water withdrawals in some eastern States such as Ohio, New York, and New Jersey. Withdrawals for public supply are largest in states with large populations, such as California, Texas, New York, and Florida.</p>
                <br><br>
                <p>This plot and map show the value of each hydrological region (HUC8) on the map by its respective proportion of public supply, irrigation, and thermoelectric power. For example, regions represented by dots in the top center are dark red because they're almost entirely comprised of public supply water use. </p>
          </div>
          <div class="viz-container">
            <img class="viz-landscape" src="../../public/images/kf08_wu_legend.png" />
          </div>
          <div class="viz-container">
            <img class="viz-landscape" src="../../public/images/kf08_wu_ternary.png" />
          </div>
          <div class="text-container">
            <h3>The proportion of groundwater to surface water use varies regionally</h3>
            <p>Across the U.S., the source of water, whether from <span class="highlight" id="groundwater">groundwater</span> or from <span class="highlight" id="surface">surface water</span> typically depends on the availability of these sources and on the category of use. On average during water years 2010-20, about 62% of water withdrawals for public supply, crop irrigation, and thermoelectric power were from surface water and 38% of withdrawals were from groundwater. </p>
            <br><br>
            <p>This data visualization shows the relative amount of water withdrawn for public supply that comes from groundwater or surface water by region. Hover over the map to see each individual region's data.</p>
          </div>
          <div class="viz-container">
            <AggReg class="agg-reg-svg"></AggReg>
            <img
                id="dumbbells"
                :src="imgSrc"
                alt=""
            >    
          </div>
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

const imgSrc = ref('@/assets/images/ws_ps_dumbbell_centered_CONUS.png');

const setDefaultImgSrc = () => {
  import(`../../public/images/k08_ws_ps_dumbbell_centered_CONUS.png`).then(img => {
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
  import(`../../public/images/k08_ws_ps_dumbbell_centered_${formattedRegionID}.png`).then(img => {
    imgSrc.value = img.default;
  });
};

const mouseoutMap = (event) => {
  const regionID = event.target.id;
  d3Base.select('.agg-reg-svg').selectAll(`#${regionID}`).style("fill", "#d1cdc0");
  import(`../../public/images/k08_ws_ps_dumbbell_centered_CONUS.png`).then(img => {
    imgSrc.value = img.default;
  });
};

onMounted(() => {
  setDefaultImgSrc();
  addInteractions();

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

.highlight {
  color: black;
  padding: 0.25px 5px;
  border-radius: 10px;
  white-space: nowrap;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.1s;

  &#groundwater {
    background-color: #E29635;
  }

  &#surface {
    background-color: #355B65;
    color: white;
  }
}

</style>