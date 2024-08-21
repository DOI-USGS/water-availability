<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
          <div class="text-container">
            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
          </div>
          <div class="viz-container">
            <AggReg class="agg-reg-svg"></AggReg>
            <img
                id="circles"
                :src="imgSrc"
                alt=""
            >    
          </div>
          <div class="text-container">
            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
          </div>
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