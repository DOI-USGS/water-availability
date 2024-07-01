<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>

        <div class="viz-container">
          <img class="viz-placeholder"
            src="@/assets/images/k03_sui_popn_CONUS.png"
          >
        </div>
        <div class="viz-container">
          <p>Hover over the map</p>
          <AggReg class="agg-reg-svg"></AggReg>
          <img
              id="smallerCircles"
              :src="imgSrc"
              alt=""
          >    
        </div>
        <PageCarousel></PageCarousel>
    </section>
</template>

<script setup>
  import { ref, onMounted } from 'vue';
  import * as d3Base from 'd3';
  import PageCarousel from '../components/PageCarousel.vue';
  import KeyMessages from '../components/KeyMessages.vue';
  import AggReg from "@/assets/svgs/AggReg.svg";

  const imgSrc = ref('@/assets/images/k03_sui_popn_CONUS.png');

  const setDefaultImgSrc = () => {
    import(`@/assets/images/k03_sui_popn_CONUS.png`).then(img => {
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
    import(`@/assets/images/k03_sui_popn_${regionID}.png`).then(img => {
      imgSrc.value = img.default;
    });
  };

  const mouseoutMap = (event) => {
    const regionID = event.target.id;
    d3Base.select('.agg-reg-svg').selectAll(`#${regionID}`).style("fill", "#d1cdc0");
    import(`@/assets/images/k03_sui_popn_CONUS.png`).then(img => {
      imgSrc.value = img.default;
    });
  };

  onMounted(() => {
    setDefaultImgSrc();
    addInteractions();
  });

</script>

<style scoped>
  #smallerCircles {
      width: 30vw;
  }
  #circles {
      width: 50vw;
  }
</style>