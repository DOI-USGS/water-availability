<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
          <div class="text-container">
            <p>In many areas of the U.S., short-term water stress is reduced by water storage in local reservoirs or by switching sources during droughts. In the Western United States, snowpack serves as an important water source, which can help sustain ecosystems and human populations during dry summer and autumn seasons (Dettinger, 2005). In other areas, water is sometimes withdrawn from one area or watershed and transported to others. These types of inter-basin transfers can be used to supplement local water supplies either seasonally or year-round and are important in for meeting the water demands for people living in high water stress areas. Public water utilities in particular often rely on transferring water from other more pristine watersheds to provide high-quality water for their customers (Liu et al., 2022). However, relying on other watersheds can leave the receiving basin vulnerable in situations where the donor basin also has a water shortage. </p>
          </div>
          <div class="viz-container">
            <img class="viz-portrait" src="../../public/images/k02_sui_popn_CONUS.png">
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