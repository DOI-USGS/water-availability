<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
          <div class="text-container">
                <p>How we use water varies across the country, including the type of use (for example, crop irrigation, public supply, and thermoelectric power) and the source of water (groundwater versus surface water). Crop irrigation is the largest category of use in the western U.S., while thermoelectric power is the largest category of use in the eastern U.S. Public supply accounts for nearly one-half of water withdrawals in some eastern States such as Ohio, New York, and New Jersey. Withdrawals for public supply are largest in states with large populations, such as California, Texas, New York, and Florida. Other categories of water use such as mining, aquaculture, livestock, and domestic and industrial (from non-public supply sources), that together account for 10% of water use in the country, can also be locally or regionally important.</p>
          </div>
          <div class="text-container">
            <p>These maps show areas where water is used for 
              <span 
                :class="['highlight', { checked: isChecked.irrigation }]" 
                id="irrigationButton"
                @click="toggleCategory('irrigation')"
              >
                crop irrigation
              </span>, 
              <span 
                :class="['highlight', { checked: isChecked.public }]" 
                id="publicButton"
                @click="toggleCategory('public')"
              >
                public supply
              </span>, thermoelectric power sourced from 
              <span 
                :class="['highlight', { checked: isChecked.teFresh }]" 
                id="teFreshButton"
                @click="toggleCategory('teFresh')"
              >
                fresh water
              </span>, and thermoelectric power sourced from 
              <span 
                :class="['highlight', { checked: isChecked.teSaline }]" 
                id="teSalineButton"
                @click="toggleCategory('teSaline')"
              >
                saline water
              </span>
            </p> for each watershed. Click the name to turn off and on the layers in the map.
          </div>
          <div class="image-container">
          <RegionMap 
          :layerVisibility="{
            irrigation: layers.irrigation.visible,
            public: layers.public.visible,
            teFresh: layers.teFresh.visible,
            teSaline: layers.teSaline.visible,
          }"
          :layerPaths="{
            irrigation: { path: layers.irrigation.path, color: layers.irrigation.color, order: layers.irrigation.order },
            public: { path: layers.public.path, color: layers.public.color, order: layers.public.order },
            teFresh: { path: layers.teFresh.path, color: layers.teFresh.color, order: layers.teFresh.order },
            teSaline: { path: layers.teSaline.path, color: layers.teSaline.color, order: layers.teSaline.order },
          }"
          regionsDataUrl="assets/Regions.topojson"
          usOutlineUrl="assets/USoutline.topojson"
          csvDataUrl="wa_stress_stats.csv"
          continuous-raw="stress_by_reg"
          continuous-percent="percentage_stress"
          categorical-variable="sui_category_5"
          regionsVar="Region_nam_nospace"
          regionsVarLabel="Region_nam"

        />
        </div>
          <div class="text-container">
            <h3>Water from above and below</h3>
            <p>Across the U.S., the source of water, whether from  <span class="highlight" id="groundwater">groundwater</span> or from <span class="highlight" id="surface">surface water</span> typically depends on the availability of these sources and on the category of use. On average during water years 2010-2020, about 62% of water withdrawals for the combination of public supply, crop irrigation, and thermoelectric power across the country were from surface water and 38% of withdrawals were from groundwater.  However, these proportions vary widely across the country, for example, for the High Plains area, 31% of withdrawals were from surface water compared to 69% from groundwater. This regional reversal of the national pattern reflects the heavy use of groundwater used for crop irrigation in the High Plains. Groundwater use also is prevalent for crop irrigation in the eastern U.S.; the western U.S. uses a nearly even mixture of groundwater and surface water for crop irrigation. In contrast, the eastern U.S., where thermoelectric power is generally the largest category of water use, is overall much more reliant on surface water. Sources of water for public-supply vary across the country, depending on the available the local water supply.</p>
            <br><br>
            <p>This data visualization shows the relative amount of water withdrawn for public supply that comes from <span class="highlight" id="groundwater">groundwater</span> or from <span class="highlight" id="surface">surface water</span> by region. The bars are placed from west to east based on the longitude (easting) of the center of each watershed. Hover over the map to see each individual region's data.</p>
          </div>
          <div class="viz-container">
            <AggReg class="agg-reg-svg"></AggReg>
            <img
                class="viz-half"
                id="dumbbells"
                :src="imgSrc"
                alt=""
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
import { ref, onMounted, inject, reactive } from 'vue';
import * as d3Base from 'd3';
import AggReg from "../../public/assets/AggReg.svg";
import PageCarousel from '../components/PageCarousel.vue';
import Methods from '../components/Methods.vue';
import KeyMessages from '../components/KeyMessages.vue';
import References from '../components/References.vue';
import RegionMap from '../components/RegionMap.vue';

// global variables
const baseURL = "https://labs.waterdata.usgs.gov/visualizations/images/water-availability/";
const defaultRegionID = "High_Plains";
const imgSrc = ref(getImgURL(defaultRegionID));
const featureToggles = inject('featureToggles');
const focalFill = "#5e7789";
const defaultFill = "#d1cdc0";

// toggle maps on and off
const isChecked = ref({
  irrigation: true,
  public: true,
  teFresh: true,
  teSaline: true
});

const layers = reactive({
  irrigation: {
    visible: true,
    path: '08_wu_ir_map.png',
    color: '#B0904F',
    order: 1
  },
  public: {
    visible: true,
    path: '08_wu_ps_map.png',
    color: '#822734',
    order: 2
  },
  teFresh: {
    visible: true,
    path: '08_wu_te_fresh_map.png',
    color: '#3E4C5B',
    order: 3
  },
  teSaline: {
    visible: true,
    path: '08_wu_te_saline_map.png',
    color: '#09A7C3',
    order: 4
  },
});


// functions called here
onMounted(() => {
  addInteractions();

  // select default region to start
  d3Base.select('.agg-reg-svg').selectAll(`#${defaultRegionID}`).style("fill", focalFill);
});

function toggleCategory(category) {
  isChecked.value[category] = !isChecked.value[category];
  addClassToImage(category);
}

function addClassToImage(category) {
	var useImage = document.getElementById(category);
  var useButton = document.getElementById(category + "Button");
  if(useImage) {
  	if(useImage.classList.contains('visible')) {
      useImage.classList.remove('visible');
      useImage.classList.add('hidden');
      useButton.classList.add('unchecked');
      useButton.classList.remove('highlight');
    }
    else {
  		useImage.classList.add('visible');
      useImage.classList.remove('hidden');
      useButton.classList.add('highlight');
      useButton.classList.remove('unchecked');
    }
  }
}

function getImgURL(id) {
  return new URL(`${baseURL}08_PS_gw_sw_dumbbell_${id}.png`);
}


function addInteractions() {
  const mapSVG = d3Base.select('.agg-reg-svg');
  mapSVG.selectAll('.AggReg_nam_nospace')
    .on("mouseover", mouseoverMap)
    .on("mouseout", mouseoutMap);
};

function mouseoverMap(event) {
  const regionID = event.target.id;
  d3Base.select('.agg-reg-svg').selectAll(`#${defaultRegionID}`).style("fill", defaultFill);
  d3Base.select('.agg-reg-svg').selectAll(`#${regionID}`).style("fill", focalFill);
  imgSrc.value = getImgURL(regionID)
};

function mouseoutMap(event) {
  const regionID = event.target.id;
  d3Base.select('.agg-reg-svg').selectAll(`#${regionID}`).style("fill", defaultFill);
  d3Base.select('.agg-reg-svg').selectAll(`#${defaultRegionID}`).style("fill", focalFill);
  imgSrc.value = getImgURL(defaultRegionID)
};

</script>


<style scoped>

.map-container {
  position: relative;
  min-height: 600px;
}
.map-overlay {
  position: absolute;
  width: 100%;
  max-width: 800px;
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

  &#irrigationButton {
    background-color: #B0904F;
  }

  &#publicButton {
    background-color: #822734;
    color: white;
  }

  &#teFreshButton {
    background-color: #3E4C5B;
    color: white;
  }

  &#teSalineButton {
    background-color: #09A7C3;
  }
}

.hidden {
  display: none;
  opacity: 0;
}

.unchecked {
  color: black;
  padding: 0.25px 5px;
  border-radius: 10px;
  white-space: nowrap;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.1s;
  background-color: grey;

  &#irrigationButton {
    background-color: grey;
  }

  &#publicButton {
    background-color: grey;
    color: white;
  }

  &#teFreshButton {
    background-color: grey;
    color: white;
  }

  &#teSalineButton {
    background-color: grey;
  }
}

</style>