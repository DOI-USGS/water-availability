<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
          <div class="text-container">
              <p>Nutrients are beneficial chemicals that support plant and animal growth. However, in high concentrations they can become pollutants and have harmful effects on human, animal, and ecosystem health.</p>
              </div>
              <div class="chart-title-container">
            <p class="chart-title">{{ showNitrogen ? 'Nitrogen' : 'Phosphorus' }} concentrations in the {{ selectedRegion === 'lower 48 United States' ? selectedRegion : `${selectedRegion} Region`}}</p>
            <p class="chart-subtitle">Total nutrient load (kg/yr) by area</p>
            <ToggleSwitch 
                v-model="showNitrogen" 
                leftLabel="Phosphorus" 
                rightLabel="Nitrogen" 
                rightColor="black"
                leftColor="black"
              />
            </div>
              <div class="image-container">
            <RegionMap 
            class="region-map"
              @regionSelected="updateSelectedRegion"
              :layerVisibility="{
                nitrogen: layers.nitrogen.visible,
                phosphorus: layers.phosphorus.visible
              }"
              :layerPaths="{
                nitrogen: { path: layers.nitrogen.path, color: layers.nitrogen.color, order: layers.nitrogen.order },
                phosphorus: { path: layers.phosphorus.path, color: layers.phosphorus.color, order: layers.phosphorus.order }
              }"
              regionsDataUrl="assets/Regions.topojson"
              usOutlineUrl="assets/USoutline.topojson"
              regionsVar="Region_nam_nospace"
              layerMag="1.11"
              layerX="-44"
              layerY="-11"

            />

            <HistogramLegend 
              :layerPaths="legendConfig"
              :data="legendData"
              :regionName="selectedRegion"
            />
          </div>
            <div class="caption-container">
              <div class="caption-text-child">
                <p>Maps showing total load of nutrients, nitrogen or phosphorus, in kilograms per year by watershed (HUC12). The histogram shows the distribution of total load across the lower 48 United States. Select a region on the map to view histograms for that region. Toggle to switch the view between nitrogen versus phosphorus loads.</p>
              </div>
            </div>
          <br>
          <br>
            <div class="text-container">
              <h3>Where do nutrients come from?</h3>
              <p>Nutrients are added to our waterways through natural sources and human activities. Human activities affect water quality through multiple pathways, including application or movement of contaminants like fertilizers or organic chemicals on the land surface from agriculture or air pollution, which generally has human origins; wastewater treatment plant discharge, and other human sources such as dredging, mining, dams, and urbanization. Natural sources of nutrients include streamfphosphorus and springs, forests, and fixation of atmospheric nitrogen by soil bacteria that is transported to streams, geogenic sources, fixation by aquatic bacteria and algae, and lightning strikes.
                </p>
            </div>
            <br>

              <div class="chart-title-container">
            <p class="chart-title">Sources of {{ showNitrogen ? 'Nitrogen' : 'Phosphorus' }} </p>
            <p class="chart-subtitle">Nutrient loads by source {{ scaleLoad ? "in kg/year" : "as a percent of total load" }}</p>
            <!-- Nutrient Toggle -->
            <ToggleSwitch 
                v-model="showNitrogen" 
                leftLabel="Phosphorus" 
                rightLabel="Nitrogen" 
                rightColor="black"
                leftColor="black"
              />

                  <!-- Scale Toggle -->
                  <ToggleSwitch 
                    v-model="scaleLoad" 
                    leftLabel="Percent load" 
                    rightLabel="Total load" 
                    rightColor="black"
                    leftColor="black"
                    inactiveColor="grey"
                  />

            </div>
          <div class="image-container">
                <div id="barplot-container">    
                </div>
            </div>
          
            <div class="caption-container-flex caption-container">
              <div class="legend-group">
                  <ColorLegend legend-id="legend-wq-agriculture" label="Agriculture" color="var(--wq-agriculture)" />
                  <ColorLegend legend-id="legend-wq-air" label="Air pollution" color="var(--wq-air)" />
                  <ColorLegend legend-id="legend-wq-wastewater" label="Wastewater" color="var(--wq-wastewater)" />
                  <ColorLegend legend-id="legend-wq-human" label="Other human sources" color="var(--wu-ps)" />
                  <ColorLegend legend-id="legend-wq-natural" label="Natural sources" color="var(--wq-natural)" />
                        </div>
              <div class="caption-text-flex caption-text-child">
                <p>Bar chart showing the load of nutrients, nitrogen or phosphorus, in kilograms per year by source for hydrologic regions in the lower 48 United States (cite van meter). Toggle to switch the view between nitrogen versus phosphorus loads or between the total load (kg/year) versus the percent (%) of the total load.</p>
              </div>
            </div> 

            <br>
            <br>
            
            <div class="text-container">
              <h3>But, aren't nutrients good for us?</h3>
              <p>Nutrients are important for all living organisms, but only in the right amounts and at the right times. Excess nutrients can affect ecosystems and people directly, such as through impaired drinking water quality and taste, but indirect effects of nutrients are far more common. For example, eutrophication occurs when excess nutrients cause algae and plants to grow overabundant in a body of water. Eutrophication is an important driver of harmful algal blooms and hypoxia (that is, extremely phosphorus dissolved oxygen), resulting in fish kills and diminished recreational uses of waterbodies.</p>
            </div>
            <br>
            <Methods></Methods>
            <References :theseReferences="referenceList"></References>
        </div>

      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>
</template>

<script setup>
import { onMounted, ref, computed, inject, reactive, watch } from 'vue';
import { useRoute } from 'vue-router';
import * as d3 from 'd3';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import references from './../assets/text/references.js';
import References from '../components/References.vue';
import SubPages from '../components/SubPages';
import { isMobile } from 'mobile-device-detect';
import RegionMap from '../components/RegionMap.vue';
import ToggleSwitch from '../components/ToggleSwitch.vue';
import HistogramLegend from '../components/HistogramLegend.vue';
import ColorLegend from '../components/ColorLegend.vue';

// use for mobile logic
const mobileView = isMobile;
const featureToggles = inject('featureToggles');
const route = useRoute();

// Global variables 
const publicPath = import.meta.env.BASE_URL;

// Chart dimensions
const containerWidth = 700; 
const maxHeight = 900; 
const margin = { top: 20, right: 20, bottom: 20, left: 250 };
let svg, chartBounds, rectGroup, nutrientScale;
let width, height;

// Reactive data elements
const scaleLoad = ref(true);
const showNitrogen = ref(true);
const legendData = ref([]);
const rawData = ref([]);
const dataSet1 = ref([]); 
const dataSet2 = ref([]); 
const selectedDataSet = ref('dataSet1');
const data = ref([]);
const selectedRegion = ref('lower 48 United States'); // default region


// References logic
// filter to this page's key message
const filteredMessages = SubPages.SubPages.filter(message => message.route === route.path);
const filteredReferences = filteredMessages[0].references;// extract list of references for this page
const refArray = references.key.sort((a, b) => a.authors.localeCompare(b.authors)); // Sort references
const theseReferences = refArray.filter((item) => filteredReferences.includes(item.refID)) // extract references that match the refID from global list
theseReferences.forEach((item, index) => { item.referenceNumber = `${index + 1}`; }); // add numbers
const referenceList = ref(theseReferences);

// Define layers and data mappings for RegionMap component
const layers = reactive({
  nitrogen: {
    visible: true,
    path: '05_tn_map.png',
    order: 1,
    colors: ['#F0EAF9', '#E8CDE3', '#DFABC9', '#D485AA', '#BC6892', '#93658F', '#71608C', '#534C7A', '#3E2E5E', '#260C3F'],
    color: 'var(--wq-high)',
    data: 'wq_loads_Reg_tn.csv',
  },
  phosphorus: {
    visible: false,
    path: '05_tp_map.png',
    order: 2,
    colors: ['#F0EAF9', '#E8CDE3', '#DFABC9', '#D485AA', '#BC6892', '#93658F', '#71608C', '#534C7A', '#3E2E5E', '#260C3F'],
    color: 'var(--wq-mod)',
    data: 'wq_loads_Reg_tp.csv',
  }
});

// WQ source bar chart configs
const orderedRegions = ["Pacific Northwest", "Columbia-Snake", "California-Nevada", "Southwest Desert", "Central Rockies", "Northern High Plains", 
"Central High Plains", "Southern High Plains", "Texas", "Gulf Coast", "Mississippi Embayment", "Tennessee-Missouri", "Atlantic Coast", "Florida", 
"Souris-Red-Rainy","Midwest", "Great Lakes", "Northeast"].reverse()

// Colors for bar chart (need to be updated along with CSS bephosphorus!)
const categoryColors = {
        'Agriculture': 'var(--wq-agriculture)',
        'Atmospheric deposition': 'var(--wq-air)',
        'Natural sources': 'var(--wq-natural)',
        'Other Human Sources': 'var(--wu-ps)',
        'Wastewater': 'var(--wq-wastewater)'
      }; 

      // run of show
onMounted(async () => {

  // set initial toggle state 
  layers.nitrogen.visible = showNitrogen.value;
  layers.phosphorus.visible = !showNitrogen.value;

  // load data that draws histogram based on nutrient toggle
  loadRegionData(); 

    try {
        await loadSourceData();
        data.value = selectedDataSet.value === 'dataSet1' ? dataSet1.value : dataSet2.value;
        if (data.value.length > 0) {

          // create svg for WQ source bar chart
            initBarChart();
            createBarChart({
              dataset: data.value,
              scaleLoad: scaleLoad.value
            });
            observeResize();
        } else {
            console.error('Error loading data');
        }
    } catch (error) {
        console.error('Error during component mounting', error);
    }
});

// general file loading fxn
async function loadData(fileName) {
  try {
    const data = await d3.csv(publicPath + fileName, d => { 
      return d;
    });
    return data;
  } catch (error) {
    console.error(`Error loading data from ${fileName}`, error);
    return [];
  }
};
async function loadSourceData() {
    dataSet1.value = await loadData('wq_sources_tn.csv');
    dataSet2.value = await loadData('wq_sources_tp.csv');
};
// load in region data for map paired chart and filter to selected region
async function loadRegionData() {
  const activeLayer = showNitrogen.value ? layers.nitrogen : layers.phosphorus; // select layer
  rawData.value = await loadData(activeLayer.data); // Load data only once and store it
  filterRegionData(); // Filter based on the current selected region
}

function filterRegionData() {
  if (!rawData.value) return; // Ensure rawData is loaded
  legendData.value = rawData.value
    .filter(d => d.Region_nam === selectedRegion.value)
    .map(d => ({
      category: d.d3_category, 
      value: +d.prop_sqkm,
    }));
}

function updateSelectedRegion(regionName) {
  selectedRegion.value = regionName;
}

/////// WQ source bar chart
// init chart svg
function initBarChart() {

  const container = document.getElementById('barplot-container');
  const containerWidth = container.clientWidth;
  width = containerWidth - margin.left - margin.right;
  height = Math.min(window.innerHeight * 0.7, 900) - margin.top - margin.bottom;

    // remove any existing SVG before redrawing
    d3.select('#barplot-container').select('svg').remove();

    // draw svg canvas for barplot
    svg = d3.select('#barplot-container')
      .append('svg')
      .attr('class', 'barplotSVG')
      .attr('viewBox', `0 0 ${containerWidth} ${height + margin.top + margin.bottom}`)
      .style('width', '100%')
      .attr('preserveAspectRatio', 'xMidYMid meet')
      //.style('max-height', `${maxHeight}px`)
      .style('height', 'auto');

    // add group for bar chart bounds, translating by chart margins
    chartBounds = svg.append('g')
      .attr('id', 'wrapper')
      .style("transform", `translate(${margin.left}, ${margin.top})`)

    // Add group to chart bounds to hold all chart rectangle groups
    rectGroup = chartBounds.append('g')
      .attr('id', 'rectangle_group')

}
// build initial chart
function createBarChart({ dataset, scaleLoad}) {
  const categoryGroups = [...new Set(dataset.map(d => d.category))];

  const expressed = scaleLoad ? 'load_1kMg' : 'percent_load';
  const stackedData = d3.stack()
    .keys(categoryGroups)
    .value(([, D], key) => D.get(key)[expressed])
    (d3.index(dataset, d => d.region_nam, d => d.category));

  const regionScale = d3.scaleBand()
    .domain(orderedRegions)
    .range([height, margin.top])
    .padding(0.1);

  nutrientScale = d3.scaleLinear()
    .domain([0, d3.max(stackedData, d => d3.max(d, d => d[1]))])
    .range([margin.left, width]);

  chartBounds.selectAll(".axis-text").remove();

  // region axis
  const regionAxis = chartBounds.append('g')
    .call(d3.axisLeft(regionScale))
    .attr('class', 'axis-text')
    .attr('transform', `translate(${margin.left}, 0)`);

  // adding maps
  regionAxis.selectAll(".tick")
    .select("text")
    .attr("x", -80) // shift text to the left to make space for the mini maps

    // load SVG and add it to each tick
    d3.xml(`${import.meta.env.BASE_URL}assets/USregions.svg`).then(function(xml) {
    const svgNode = xml.documentElement;

    regionAxis.selectAll(".tick")
      .each(function(d) {
        const regionClass = d.replace(/\s+/g, '_'); 

        // the mini map to use for each tick
        const svgClone = svgNode.cloneNode(true);

        // add the map at each tick
        const insertedSvg = d3.select(this)
          .insert(() => svgClone, "text") 
          .attr("x", -66) 
          .attr("y", -30) 
          .attr("width", 60) 
          .attr("height", 60)
          .attr("fill", "lightgrey"); 

        // select the <g> element with the region name
        insertedSvg.selectAll(`g.${regionClass} path`) // grab the path
          .attr("stroke", "black") // apply black outline
          .attr("stroke-width", 3)
          .attr("fill", "black"); 
      });
  });

  // x-axis at the bottom
  chartBounds.append('g')
    .attr('transform', `translate(0, ${height})`)
    .call(d3.axisBottom(nutrientScale).ticks(4).tickFormat(d => scaleLoad ? d + 'M' : d + "%"))
    .attr('class', 'axis-text');

  // x-axis at the top
  chartBounds.append('g')
    .attr('transform', `translate(0, ${margin.top})`) // positioned at y = 0 (top of the chart)
    .call(d3.axisTop(nutrientScale).ticks(4).tickFormat(d => scaleLoad ? d + 'M' : d + "%"))
    .attr('class', 'axis-text');

  const colorScale = d3.scaleOrdinal()
    .domain(categoryGroups)
    .range(categoryGroups.map(item => categoryColors[item]));

  const dur = 1000;
  const t = d3.transition().duration(dur);

  const categoryRectGroups = rectGroup.selectAll('g')
    .data(stackedData, d => d.key)
    .join(
      enter => enter.append("g")
        .attr("class", d => d.key.replace(" ", "_")),
      update => update,
      exit => exit.remove()
    );

  categoryRectGroups.selectAll('rect')
    .data(D => D.map(d => (d.key = D.key, d)))
    .join(
      enter => enter.append("rect")
        .attr('x', d => nutrientScale(d[0]))
        .attr('y', d => regionScale(d.data[0]))
        .attr('height', regionScale.bandwidth())
        .attr('width', d => nutrientScale(d[1]) - nutrientScale(d[0]))
        .style("fill", d => colorScale(d.key))
        .style("opacity", 0)
        .transition(t)
        .style("opacity", 1),

      update => update.transition(t)
        .attr('x', d => nutrientScale(d[0]))
        .attr('y', d => regionScale(d.data[0]))
        .attr('height', regionScale.bandwidth())
        .attr('width', d => nutrientScale(d[1]) - nutrientScale(d[0])),

      exit => exit.transition(t)
        .style("opacity", 0)
        .remove()
    );
}

// dynamic scaling based on container width
const resizeChart = () => {
  const container = document.getElementById('barplot-container');
  const containerWidth = container.clientWidth;

  // dynamically adjust width and height
  width = containerWidth - margin.left - margin.right;
  height = Math.min(window.innerHeight * 0.7, 900) - margin.top - margin.bottom;

  // update svg viewBox
  svg.attr('viewBox', `0 0 ${containerWidth} ${height + margin.top + margin.bottom}`)
     .attr('preserveAspectRatio', 'xMidYMid meet');

  // redraw chart
  createBarChart({ dataset: dataset.value, scaleLoad: scaleLoad.value });
};
// handle resize
const observeResize = () => {
  const resizeObserver = new ResizeObserver(() => resizeChart());
  resizeObserver.observe(document.getElementById('barplot-container'));
};


// COMPUTED VARIABLES 
// compute legendConfig dynamically based on the toggle
const legendConfig = computed(() => {
  return showNitrogen.value
    ? { colors: layers.nitrogen.colors, name: 'Nitrogen' }
    : { colors: layers.phosphorus.colors, name: 'Phosphorus' };
    
});

// WATCHERS
// watch for changes to scaleLoad
watch(scaleLoad, (newValue) => {
  // update the chart based on the new scale
  createBarChart({
    dataset: data.value,
    scaleLoad: newValue // dynamically pass the toggle state
  });


});

// watch for changes to showNitrogen
watch(showNitrogen, async (newValue) => {
  // update the chart based on the nutrient type
  data.value = newValue ? dataSet1.value : dataSet2.value;
  await loadRegionData(); // reload data when the toggle changes

  createBarChart({
    dataset: data.value,
    scaleLoad: scaleLoad.value 
  });


  // toggle map layer visibility based on the nutrient selected
  layers.nitrogen.visible = newValue;   // show nitrogen layer
  layers.phosphorus.visible = !newValue; // hide phosphorus layer
});

watch([selectedRegion], filterRegionData)

</script>

<style scoped lang="scss">

#barplot-container {
  position: relative;
  width: 100%; 
  max-height: 900px;
  max-width: 1800px;
  margin: auto;
}
.image-container {
  position: relative;
  width: 100%; 
  max-width: 1800px;
  margin: auto; 
  overflow: hidden;
}
.region-map {
  height: 600px;
}
@media only screen and (max-width: 768px) {
  #barplot-container {
    width: 100%; 
  }
}

</style>