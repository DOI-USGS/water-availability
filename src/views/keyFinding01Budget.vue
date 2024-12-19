<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <p>Water balance is the difference between how much clean water is in supply and how much water is in demand. For most of the country, water supply is much higher than water demand, meaning there is more than enough water available to meet our needs. However, in arid and semiarid parts of the U.S. such as the southwest and the high plains, the differences between water supply and demand are smaller, and limitations on water are more common.  
                  </p>
            </div>
            <div class="caption-container">
              <div class="caption-text-child">
                <p>This chart shows the average annual water supply and demand in millimeters per year. Toggle the layers on and off with these buttons. </p>
              </div>
              <div class="caption-legend-child">
                <div class="checkbox_item" id="checkbox-demand" >
                  <label class="checkbox_wrap">
                  <input type="checkbox" 
                  name="checkbox" 
                  class="checkbox_inp" 
                  @click="togglePoints('demand')">
                  <span class="checkbox_mark"></span>
                  Water demand
                  </label>
                </div>
                <div class="checkbox_item" id="checkbox-supply" >
                  <label class="checkbox_wrap">
                    <input type="checkbox" 
                    name="checkbox" 
                    class="checkbox_inp" 
                    @click="togglePoints('supply')">
                    <span class="checkbox_mark"></span>
                    Water supply
                  </label>
                </div>
              </div>
          </div>
        <div class="viz-container">
          
          <div id="dotplot-container">             
            
        </div>   
        </div>
        <div class="text-container">
        <p>
          Water limitation occurs when water use is a high percentage of surface-water supply and therefore there is not enough water available to meet human and ecosystem needs. Water limitation is calculated based on a water supply and use index, which is a way of showing the imbalance between surface water-supply and consumptive uses. Between 2010 and 2020, the Southern High Plains, Central High Plains, Texas, Mississippi Embayment, and Southwest Desert had the most widespread exposure to local water limitation in the country. These competing needs are projected to increase because of future global population growth and increasing food demands, as well as climatic changes, which could further aggravate the imbalance between human water uses and environmental flow requirements. 
        </p>
        </div>
        <div class="caption-container">
              <div class="caption-text-child">
                <p>This map shows levels of water limitation for each watershed (HUC12). The bar chart shows the proportion of each water limitation category. Toggle the levels of water limitation on and off with these buttons. Hover over the map to see regional summaries.</p>
              </div>
              <div class="caption-legend-child">
                <div class="checkbox_item" id="checkbox-sui-none" >
                  <label class="checkbox_wrap">
                  <input type="checkbox" 
                  name="checkbox" 
                  class="checkbox_inp" 
                  @click="toggleLayer('very_low_none')">
                  <span class="checkbox_mark"></span>
                    Very low water limitation
                  </label>
                </div>
                <div class="checkbox_item" id="checkbox-sui-low" >
                  <label class="checkbox_wrap">
                  <input type="checkbox" 
                  name="checkbox" 
                  class="checkbox_inp" 
                  @click="toggleLayer('low')">
                  <span class="checkbox_mark"></span>
                    Low water limitation
                  </label>
                </div>
                <div class="checkbox_item" id="checkbox-sui-mod" >
                  <label class="checkbox_wrap">
                  <input type="checkbox" 
                  name="checkbox" 
                  class="checkbox_inp" 
                  @click="toggleLayer('moderate')">
                  <span class="checkbox_mark"></span>
                    Moderate water limitation
                  </label>
                </div>
                <div class="checkbox_item" id="checkbox-sui-high" >
                  <label class="checkbox_wrap">
                  <input type="checkbox" 
                  name="checkbox" 
                  class="checkbox_inp" 
                  @click="toggleLayer('high')">
                  <span class="checkbox_mark"></span>
                    High water limitation
                  </label>
                </div>
                <div class="checkbox_item" id="checkbox-sui-severe" >
                  <label class="checkbox_wrap">
                  <input type="checkbox" 
                  name="checkbox" 
                  class="checkbox_inp" 
                  @click="toggleLayer('severe')">
                  <span class="checkbox_mark"></span>
                    Severe water limitation
                  </label>
                </div>
              </div>
        </div>    
        <div class="image-container">
          <StackedBar 
            categoricalVariable="d3_category"
            continuousRaw="stress_by_reg"
            continuousPercent="d3_percentage"
            :layerPaths="{
            very_low_none: { path: layers.very_low_none.path, color: layers.very_low_none.color, order: layers.very_low_none.order },
            low: { path: layers.low.path, color: layers.low.color, order: layers.low.order },
            moderate: { path: layers.moderate.path, color: layers.moderate.color, order: layers.moderate.order },
            high: { path: layers.high.path, color: layers.high.color, order: layers.high.order },
            severe: { path: layers.severe.path, color: layers.severe.color, order: layers.severe.order },
          }"
            :data="csvData"
            :regionName="selectedRegion"
            />
          <RegionMap 
          @regionSelected="updateSelectedRegion"
          :layerVisibility="{
            very_low_none: layers.very_low_none.visible,
            low: layers.low.visible,
            moderate: layers.moderate.visible,
            high: layers.high.visible,
            severe: layers.severe.visible,
          }"
          :layerPaths="{
            very_low_none: { path: layers.very_low_none.path, color: layers.very_low_none.color, order: layers.very_low_none.order },
            low: { path: layers.low.path, color: layers.low.color, order: layers.low.order },
            moderate: { path: layers.moderate.path, color: layers.moderate.color, order: layers.moderate.order },
            high: { path: layers.high.path, color: layers.high.color, order: layers.high.order },
            severe: { path: layers.severe.path, color: layers.severe.color, order: layers.severe.order },
          }"
          regionsDataUrl="assets/Regions.topojson"
          usOutlineUrl="assets/USoutline.topojson"
          regionsVar="Region_nam_nospace"

        />
        </div>
        <div class="text-container">
          <h2>Local and seasonal effects of water limitation</h2>
          <p>Even in regions where average conditions show lower water limitation, water shortages can happen on local scales or for short periods such as during droughts or dry seasons. In many parts of the U.S., water use peaks during dry summer months when crop irrigation demands are at their maximum and outdoor use of public-supply water is highest (Medalie et al., 2025). Thus, lower supply is often matched with increased use, which increases water limitation for local watersheds.</p>
        </div>
        <Methods></Methods>
      <References></References>
      </div>
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>
</template>

<script setup>
import { onMounted, ref, reactive, inject } from 'vue';
import * as d3 from 'd3';
import PageCarousel from '../components/PageCarousel.vue';
import RegionMap from '../components/RegionMap.vue';
import StackedBar from '../components/StackedBar.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import References from '../components/References.vue';
import { isMobile } from 'mobile-device-detect';

const featureToggles = inject('featureToggles');

const mobileView = isMobile;

const publicPath = import.meta.env.BASE_URL;
const dataSet1 = ref([]); 
const data = ref([]);
const csvData = ref([]);
const selectedRegion = ref('United States'); // default region
let svg;
const containerWidth = window.innerWidth * 0.45;
const containerHeight = mobileView ? window.innerHeight * 0.8 : window.innerHeight * 0.5;
let margin = { top: 50, right: 50, bottom: 40, left: 200 };
let width = containerWidth - margin.left - margin.right;
let height = containerHeight - margin.top - margin.bottom;
let chartBounds, dotGroup;
let xScale;
let originalXScaleDomain;

let showSupply = ref(true);
let showDemand = ref(true);

const orderedRegions = [
    "Pacific Northwest", "Columbia-Snake", "California-Nevada", "Southwest Desert", "Central Rockies", "Northern High Plains", 
    "Central High Plains", "Southern High Plains", "Texas", "Gulf Coast", "Mississippi Embayment", "Tennessee-Missouri", "Atlantic Coast", 
    "Florida", "Souris-Red-Rainy", "Midwest", "Great Lakes", "Northeast"
];

const layers = reactive({
  very_low_none: {
    visible: true,
    path: '01_stress_map_very_low_none.png',
    color: 'var(--sui-none)',
    order: 1
  },
  low: {
    visible: true,
    path: '01_stress_map_low.png',
    color: 'var(--sui-low)',
    order: 2
  },
  moderate: {
    visible: true,
    path: '01_stress_map_moderate.png',
    color: 'var(--sui-mod)',
    order: 3
  },
  high: {
    visible: true,
    path: '01_stress_map_high.png',
    color: 'var(--sui-high)',
    order: 4
  },
  severe: {
    visible: true,
    path: '01_stress_map_severe.png',
    color: 'var(--sui-severe)',
    order: 5
  }
});

	
 
// regional selection data
const csvWA = "wa_stress_stats.csv"
function updateSelectedRegion(regionName) {
  selectedRegion.value = regionName;
}


// function to toggle layer visibility
const toggleLayer = (layerId) => {
  layers[layerId].visible = !layers[layerId].visible;
}


onMounted(async () => {
    try {
        await loadDatasets();
        data.value = dataSet1.value;
        if (data.value.length > 0) {
            initDotChart();
            createDotChart();
        } else {
            console.error('Error loading data');
        }
    } catch (error) {
        console.error('Error during component mounting', error);
    }
});

async function loadDatasets() {
  dataSet1.value = await loadData('wa_supply_demand.csv');
  csvData.value = await d3.csv(`${publicPath}${csvWA}`);
}

async function loadData(fileName) {
    try {
        const data = await d3.csv(publicPath + fileName, d => d);
        return data;
    } catch (error) {
        console.error(`Error loading data from ${fileName}`, error);
        return [];
    }
}

function initDotChart() {
    d3.select('#dotplot-container').select('svg').remove();

    svg = d3.select('#dotplot-container')
      .append('svg')
      .attr('viewBox', `0 0 ${containerWidth} ${containerHeight}`)
      .style('width', '100%')
      .style('height', 'auto');

    chartBounds = svg.append('g')
      .attr('transform', `translate(${margin.left}, 20)`);

    dotGroup = chartBounds.append('g');
}


function togglePoints(type) {
    if (type === "supply") {
        showSupply.value = !showSupply.value;
    } else if (type === "demand") {
        showDemand.value = !showDemand.value;
    }

    // Get the visible supply and demand points based on the toggles
    const visibleSupply = showSupply.value ? data.value.map(d => +d.supply_mean) : [];
    const visibleDemand = showDemand.value ? data.value.map(d => +d.demand_mean) : [];

    const visiblePoints = [...visibleSupply, ...visibleDemand];
    const newDomain = visiblePoints.length > 0 ? d3.extent(visiblePoints) : originalXScaleDomain;

    // Update the x-axis domain based on visible points
    xScale.domain(newDomain).nice();

    // Transition the x-axis
    d3.selectAll(".x-axis-bottom")
        .transition()
        .duration(500)
        .call(d3.axisBottom(xScale).ticks(5));

    d3.selectAll(".x-axis-top")
        .transition()
        .duration(500)
        .call(d3.axisTop(xScale).ticks(5));

    // Update the position of the circles and hide/show based on the toggles
    d3.selectAll(".circle-supply")
        .transition()
        .duration(500)
        .attr('cx', d => xScale(d.supply_mean))
        .style("opacity", showSupply.value ? 1 : 0); // toggle opacity based on showSupply

    d3.selectAll(".circle-demand")
        .transition()
        .duration(500)
        .attr('cx', d => xScale(d.demand_mean))
        .style("opacity", showDemand.value ? 1 : 0); // toggle opacity based on showDemand

    // Transition the lines connecting supply and demand
    d3.selectAll(".line")
        .transition()
        .duration(500)
        .attr('x1', d => xScale(d.supply_mean))
        .attr('x2', d => xScale(d.demand_mean))
        .style("opacity", showSupply.value && showDemand.value ? 0.4 : 0); // only show if both supply and demand are visible
}




function createDotChart() {
    const dataset = data.value;

    if (!dataset || dataset.length === 0) {
        console.error("No dataset available for creating the dot chart");
        return;
    }

    const yAccessor = d => d["Region_nam"];

    const xScaleDomain = d3.extent([
        ...dataset.map(d => +d.supply_mean),
        ...dataset.map(d => +d.demand_mean)
    ]);
    xScale = d3.scaleLinear()
        .domain(xScaleDomain)
        .range([0, width - 2 * margin.right])
        .nice();

    originalXScaleDomain = xScale.domain(); 

    const yScale = d3.scaleBand()
        .domain(dataset.map(yAccessor))
        .range([0, height])
        .padding(0.1);

    dotGroup.selectAll("*").remove();

    dotGroup.append('g')
        .attr('class', 'x-axis-bottom x-axis')
        .attr('transform', `translate(0, ${height})`)
        .call(d3.axisBottom(xScale).ticks(5));

    dotGroup.append('g')
        .attr('class', 'x-axis-top x-axis')
        .call(d3.axisTop(xScale).ticks(5));

    dotGroup.append('g')
        .attr('class', 'y-axis')
        .call(d3.axisLeft(yScale));

    const regionAxis = dotGroup.select('.y-axis')
      .selectAll(".tick")
      .select("text")
      .attr("x", -44)
      .attr("dy", "0.32em");

    d3.xml(`${publicPath}assets/USregions.svg`).then(function(xml) {
      const svgNode = xml.documentElement;

      dotGroup.select('.y-axis')
        .selectAll(".tick")
        .each(function(d) {
          const regionClass = d.replace(/\s+/g, '_');
          const svgClone = svgNode.cloneNode(true);

          const insertedSvg = d3.select(this)
            .insert(() => svgClone, "text")
            .attr("x", -40)
            .attr("y", -20)
            .attr("width", 40)
            .attr("height", 40)
            .attr("fill", "var(--inactive-grey)");

          insertedSvg.selectAll(`g.${regionClass} path`)
            .attr("stroke", "black")
            .attr("stroke-width", 3)
            .attr("fill", "black");
        });
    });

    dotGroup.selectAll(".line")
        .data(dataset)
        .enter().append('line')
        .attr('class', 'line')
        .attr('x1', d => xScale(d.supply_mean))
        .attr('x2', d => xScale(d.demand_mean))
        .attr('y1', d => yScale(d.Region_nam) + yScale.bandwidth() / 2)
        .attr('y2', d => yScale(d.Region_nam) + yScale.bandwidth() / 2)
        .attr('stroke', '#ccc')
        .attr('stroke-width', 3)
        .attr("stroke-opacity", 0.5);

    dotGroup.selectAll(".circle-supply")
        .data(dataset)
        .enter().append('circle')
        .attr('class', 'circle-supply')
        .attr('cx', d => xScale(d.supply_mean))
        .attr('cy', d => yScale(d.Region_nam) + yScale.bandwidth() / 2)
        .attr('r', 5)
        .attr('fill', 'var(--ws-supply)');

    dotGroup.selectAll(".circle-demand")
        .data(dataset)
        .enter().append('circle')
        .attr('class', 'circle-demand')
        .attr('cx', d => xScale(d.demand_mean))
        .attr('cy', d => yScale(d.Region_nam) + yScale.bandwidth() / 2)
        .attr('r', 5)
        .attr('fill', 'var(--ws-demand)');
}
</script>


<style scoped>
.content-container {
  display: block;
  margin: 0 auto;
  padding: 0px;
}
#viz-container {
  width: 100%;
  max-width: 600px;
  margin: 20px auto;
  display: block;
}
#dotplot-container{
  width: 100%;
  min-height: 600px;
}
.text-container {
  margin: 20px auto;
}
.image-container {
  position: relative;
  width: 100%; 
  max-width: 1800px;
  margin: auto; 
  overflow: hidden;
}

.background-image {
  width: 100%;
  height: 500px;
  object-fit: cover; 
  object-position: center;
  display: block;
}
.overlay-svg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}
.region-label {
  font-size: 14px;
  font-weight: bold;
  fill: black; 
  pointer-events: none; /* Prevents the label from interfering with mouse events */
}


#toggle-supply {
  margin-left: 10px;
  background-color: #669999;
}

#toggle-demand {
  margin-left: 10px;
  background-color: #F87A53;
}



.highlight {
  color: white;
  padding: 0.25px 5px;
  border-radius: 10px;
  white-space: nowrap;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.1s;

  &#supply {
    background-color: var(--ws-supply);
  }

  &#demand {
    background-color: var(--ws-demand);
  }

  &#very_low_none {
    background-color: var(--sui-none);
  }

  &#low {
    background-color: var(--sui-low);
    color: black;
  }

  &#moderate {
    background-color: var(--sui-mod);
    color: black;
  }

  &#high {
    background-color: var(--sui-high);
    color: black;
  }

  &#severe {
    background-color: var(--sui-severe);
  }
}
.supply {
  background-color: var(--ws-supply);
}

.demand {
  background-color: var(--ws-demand);
}
.highlight.inactive-toggle {
  background-color: var(--inactive-grey); 
  color: black;
  &#very_low_none {
    background-color: var(--inactive-grey); 
  }
  &#low {
    background-color: var(--inactive-grey); 
  }
  &#moderate {
    background-color: var(--inactive-grey); 
  }
  &#high {
    background-color: var(--inactive-grey); 
  }
  &#severe {
    background-color: var(--inactive-grey); 
  }
}

</style>