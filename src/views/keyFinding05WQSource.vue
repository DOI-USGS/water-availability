<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
          <div class="text-container">
              <p>Nutrients are beneficial chemicals that support plant and animal growth. However, in high concentrations they can become pollutants and have harmful effects on human, animal, and ecosystem health.</p>
              </div>
              <div class="caption-container">
              <div class="checkbox_item">
              <!-- Nutrient Toggle -->
              <ToggleSwitch 
                v-model="showNitrogen" 
                leftLabel="Phosphorus" 
                rightLabel="Nitrogen" 
              />
            </div>

                <div class="checkbox_item">
                  <!-- Scale Toggle -->
                  <ToggleSwitch 
                    v-model="scaleLoad" 
                    leftLabel="Percent load" 
                    rightLabel="Total load" 
                  />
                </div>
              </div>
          <div class="viz-container">
                <div id="barplot-container">    
                </div>
            </div>
            <div class="caption-container">
                <div class="caption-legend-child">
                <div class="legend_item" id="legend-wq-agriculture" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                    Agriculture
                  </label>
                </div>
                <div class="legend_item" id="legend-wq-air" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                    Air pollution
                  </label>
                </div>
                <div class="legend_item" id="legend-wq-wastewater" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                    Wastewater
                  </label>
                </div>
                <div class="legend_item" id="legend-wq-human" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                    Other human sources
                  </label>
                </div>
                <div class="legend_item" id="legend-wq-natural" >
                  <label class="legend_wrap">
                  <input type="legend" name="legend" class="legend-inp">
                  <span class="legend_mark"></span>
                    Natural sources
                  </label>
                </div>
              </div>
              <div class="caption-text-child">
                <p>A bar chart showing the source of nutrients for hydrologic regions in CONUS. Use the toggle to show either nitrogen or phosphorus. Use the toggle to see the total load (Mg/year) or the percent of the total load</p>
              </div>
            </div> 
            <div class="text-container">
              <p>Nutrients are added to our waterways through natural sources and human activities. Humans modify water quality by...  Human activities affect water quality through multiple pathways, including application or movement of contaminants like fertilizers or organic chemicals on the land surface from agriculture or air pollution, which generally has human origins; wastewater treatment plant discharge, and other human sources such as dredging, mining, dams, and urbanization. Natural sources of nutrients include streamfphosphorus and springs, forests, and fixation of atmospheric nitrogen by soil bacteria that is transported to streams, geogenic sources, fixation by aquatic bacteria and algae, and lightning strikes.
                </p>
            </div>
            <div class="checkbox_item">
              <ToggleSwitch 
                v-model="showNitrogen" 
                leftLabel="Phosphorus" 
                rightLabel="Nitrogen" 
              />
            </div>
            <RegionMap 
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
            <div class="caption-container">
              <div class="caption-text-child">
                <p>These maps show total nutrient load in kilograms per year for each watershed (HUC12). Use the button to toggle between total nitrogen load and phosphorus load.</p>
              </div>
              </div>
            <div class="text-container">
              <h3>Effects of nutrients in the water</h3>
              <p>Increased water demands can increase the release of previously trapped contaminants into the water supply. Although excess nutrients can affect ecosystems and people directly, such as through impaired drinking water quality and taste, indirect effects of nutrients are far more common. For example, eutrophication occurs when excess nutrients cause algae and plants to grow overabundant in a body of water. Eutrophication is an important driver of harmful algal blooms and hypoxia (that is, extremely phosphorus dissolved oxygen), resulting in fish kills and diminished recreational uses of waterbodies.</p>
            </div>
            <Methods></Methods>
            <References></References>
        </div>


         
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>
</template>

<script setup>
import { onMounted, ref, inject, reactive, watch } from 'vue';
import * as d3 from 'd3';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import References from '../components/References.vue';
import { isMobile } from 'mobile-device-detect';
import RegionMap from '../components/RegionMap.vue';
import ToggleSwitch from '../components/ToggleSwitch.vue';

// use for mobile logic
const mobileView = isMobile;
const featureToggles = inject('featureToggles');

// Global variables 
const publicPath = import.meta.env.BASE_URL;
const dataSet1 = ref([]); 
const dataSet2 = ref([]); 
const selectedDataSet = ref('dataSet1');
const data = ref([]);
let svg;
const containerWidth = Math.min(window.innerWidth * 0.9, 1200); 
const containerHeight = Math.max(window.innerHeight * 0.9, 600); // Min height 600px
const maxHeight = 900; 
const margin = mobileView ? { top: 60, right: 50, bottom: 20, left: 100 } : { top: 100, right: 100, bottom: 40, left: 300 };
const width = containerWidth - margin.left - margin.right;
const height = containerHeight - margin.top - margin.bottom;
let chartBounds, rectGroup;
let nutrientScale;

const scaleLoad = ref(true);
const showNitrogen = ref(true);

const layers = reactive({
  nitrogen: {
    visible: true,
    path: '05_tn_map.png',
    color: 'var(--wq-high)',
    order: 1
  },
  phosphorus: {
    visible: false,
    path: '05_tp_map.png',
    color: 'var(--wq-mod)',
    order: 2
  }
});

const orderedRegions = ["Pacific Northwest", "Columbia-Snake", "California-Nevada", "Southwest Desert", "Central Rockies", "Northern High Plains", 
"Central High Plains", "Southern High Plains", "Texas", "Gulf Coast", "Mississippi Embayment", "Tennessee-Missouri", "Atlantic Coast", "Florida", 
"Souris-Red-Rainy","Midwest", "Great Lakes", "Northeast"].reverse()

// Colors for bar chart (need to be updated along with CSS bephosphorus!)
const categoryColors = {
        'Agriculture': 'var(--wq-sediment)',
        'Atmospheric deposition': 'var(--wq-air)',
        'Natural sources': 'var(--wq-natural)',
        'Other Human Sources': 'var(--wu-ps)',
        'Wastewater': 'var(--ws-supply)'
      }; 

onMounted(async () => {
  // sync initial state with toggles
  layers.nitrogen.visible = showNitrogen.value;
  layers.phosphorus.visible = !showNitrogen.value;

    try {
        await loadDatasets();
        data.value = selectedDataSet.value === 'dataSet1' ? dataSet1.value : dataSet2.value;
        if (data.value.length > 0) {
            initBarChart({
              containerWidth: containerWidth,
              containerHeight: containerHeight,
              margin: margin,
              width: width,
              height: height
            });
            createBarChart({
              dataset: data.value,
              scaleLoad: scaleLoad.value
            });
        } else {
            console.error('Error loading data');
        }
    } catch (error) {
        console.error('Error during component mounting', error);
    }
});

async function loadDatasets() {
  try {
    dataSet1.value = await loadData('wq_sources_tn.csv');
    dataSet2.value = await loadData('wq_sources_tp.csv');
    console.log('data in');
  } catch (error) {
    console.error('Error loading datasets', error);
  }
};

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

function initBarChart({
  containerWidth,
  containerHeight,
  margin
}) {

    // draw svg canvas for barplot
    svg = d3.select('#barplot-container')
      .append('svg')
      .attr('class', 'barplotSVG')
      .attr('viewBox', `0 0 ${containerWidth} ${containerHeight}`)
      .style('width', containerWidth)
      .style('height', containerHeight)
      .style('max-height', `${maxHeight}px`);

    // add group for bar chart bounds, translating by chart margins
    chartBounds = svg.append('g')
      .attr('id', 'wrapper')
      .style("transform", `translate(${margin.left}px, ${margin.top}px)`)

    // Add group to chart bounds to hold all chart rectangle groups
    rectGroup = chartBounds.append('g')
      .attr('id', 'rectangle_group')

}
function createBarChart({
  dataset,
  scaleLoad
}) {
  const categoryGroups = [...new Set(dataset.map(d => d.category))];

  const expressed = scaleLoad ? 'load_1kMg' : 'percent_load';
  const stackedData = d3.stack()
    .keys(categoryGroups)
    .value(([, D], key) => D.get(key)[expressed])
    (d3.index(dataset, d => d.region_nam, d => d.category));

  const regionScale = d3.scaleBand()
    .domain(orderedRegions)
    .range([height, 0])
    .padding(0.1);

  nutrientScale = d3.scaleLinear()
    .domain([0, d3.max(stackedData, d => d3.max(d, d => d[1]))])
    .range([0, width]);

  chartBounds.selectAll(".axis-text").remove();

  // region axis
  const regionAxis = chartBounds.append('g')
    .call(d3.axisLeft(regionScale))
    .attr('class', 'axis-text');

  // adding maps
  regionAxis.selectAll(".tick")
    .select("text")
    .attr("x", -80) // shift text to the left to make space for the mini maps
    .attr("dy", "0.32em")
    //.attr("font-weight", "bold");

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
    .call(d3.axisBottom(nutrientScale).ticks(4).tickFormat(d => scaleLoad ? d + 'k' : d + "%"))
    .attr('class', 'axis-text');

  // x-axis at the top
  chartBounds.append('g')
    .attr('transform', 'translate(0, 0)') // positioned at y = 0 (top of the chart)
    .call(d3.axisTop(nutrientScale).ticks(4).tickFormat(d => scaleLoad ? d + 'k' : d + "%"))
    .attr('class', 'axis-text');

  // updating x-axis label
  svg.append("text")
    .attr("class", "upper-right-label")
    .attr("x", containerWidth - margin.right-100) 
    .attr("y", margin.top / 2)
    .attr("text-anchor", "end") // anchor to the end of the text
    .style("font-size", "2.5rem")
    .style("font-weight", "bold")
    .text(showNitrogen.value ? "Nitrogen" : "Phosphorus"); 

  // italic units label
  svg.append("text")
    .attr("class", "upper-right-label-explained")
    .attr("x", containerWidth - margin.right) 
    .attr("y", margin.top / 2) 
    .attr("text-anchor", "end")
    .style("font-size", "2.5rem")
    .style("font-style", "italic")
    .style("font-weight", "300")
    .text(scaleLoad.value ? "Percent" : "Mg/year");

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

// update x-axis labels
function updateLabels() {

  const label = svg.selectAll(".upper-right-label")
    .data([null]); // Use a dummy data binding to handle enter/update/exit

  label.enter()
    .append("text")
    .attr("class", "upper-right-label")
    .attr("x", containerWidth - margin.right -100)
    .attr("y", margin.top / 2)
    .attr("text-anchor", "end")
    .style("font-size", "2rem")
    .style("font-weight", "bold")
    .merge(label) 
    .text(showNitrogen.value ? "Nitrogen" : "Phosphorus");

  label.exit().remove(); // Ensure old labels are removed

  const explainedLabel = svg.selectAll(".upper-right-label-explained")
    .data([null]); 

  explainedLabel.enter()
    .append("text")
    .attr("class", "upper-right-label-explained")
    .attr("x", containerWidth - margin.right)
    .attr("y", margin.top / 2 )
    .attr("text-anchor", "end")
    .style("font-size", "2rem")
    .style("font-style", "italic")
    .style("font-weight", "300")
    .merge(explainedLabel) 
    .text(scaleLoad.value ? "Mg/year" : "Percent");

  explainedLabel.exit().remove(); 
}

// watch for changes to scaleLoad
watch(scaleLoad, (newValue) => {
  // update the chart based on the new scale
  createBarChart({
    dataset: data.value,
    scaleLoad: newValue // dynamically pass the toggle state
  });

  // update chart labels to match scale
  updateLabels();
});
// watch for changes to showNitrogen
watch(showNitrogen, (newValue) => {
  // update the chart based on the nutrient type
  data.value = newValue ? dataSet1.value : dataSet2.value;

  createBarChart({
    dataset: data.value,
    scaleLoad: scaleLoad.value 
  });

  // update chart labels
  updateLabels();

  // toggle map layer visibility based on the nutrient selected
  layers.nitrogen.visible = newValue;          // show nitrogen layer
  layers.phosphorus.visible = !newValue;      // hide phosphorus layer
});
</script>

<style scoped lang="scss">
.viz-container {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%; 
  min-height: 600px; 
  max-height: 900px;
  margin: auto;
}

#barplot-container {
  width: 100%; 
  max-height: 900px;
}

@media only screen and (max-width: 768px) {
  #barplot-container {
    width: 100%; 
  }
}
.svg-icon path {
  fill: var(--ws-supply);
}

.highlight {
  color: white;
  padding: 0.25px 5px;
  border-radius: 10px;
  white-space: nowrap;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.1s;

  &#Agriculture {
    background-color: #939185;
  }

  &#Atmosphericdeposition {
    background-color: #C8ACD6;
  }

  &#Otherhumansources {
    background-color: #2E236C;
  }

  &#Wastewater {
    background-color: #478CCF;
  }

  &#Naturalsources {
    background-color: #EECEB9;
  }

}
$switchWidth: 7.9rem;
.graph-buttons-switch {
  display: flex;
  height: 2.8rem;
  width: $switchWidth * 2.03;
  border-radius: 0.2rem;
  position: relative;
  margin: 0rem 0.5rem 0rem 0.5rem;
  background: rgba(0, 0, 0, 0.3);
  -webkit-box-shadow: inset 0 0.1rem 0.3rem rgba(0, 0, 0, 0.1), 0 0.1remx rgba(255, 255, 255, 0.1);
  box-shadow: inset 0 0.1rem 0.3rem rgba(0, 0, 0, 0.1), 0 0.1rem rgba(255, 255, 255, 0.1);

    -webkit-touch-callout: none; /* iOS Safari */
    -webkit-user-select: none; /* Safari */
    -khtml-user-select: none; /* Konqueror HTML */
      -moz-user-select: none; /* Firefox */
        -ms-user-select: none; /* Internet Explorer/Edge */
            user-select: none; /* Non-prefixed version, currently
                                  supported by Chrome and Opera */
  @media screen and (max-width: 600px) {
    height: 2.6rem;
  }
}
.graph-buttons-switch-label {
  position: relative;
  z-index: 2;
  float: left;
  width: $switchWidth;
  line-height: 2.4rem;
  text-align: center;
  cursor: pointer;
  @media screen and (max-width: 600px) {
    line-height: 2.2rem;
    width: $switchWidth * 1.02;
  }
}
.graph-buttons-switch-label-off {
  padding-left: 0.2rem;
  padding-right: 0.2rem;
}
.graph-buttons-switch-label-on {
  padding-left: 0.2rem;
  padding-right: 0.2rem;
}
.graph-buttons-switch-input {display: none;}
.graph-buttons-switch-input:checked + .graph-buttons-switch-label {
  font-weight: bold;
  -webkit-transition: 0.3s ease-out;
  -moz-transition: 0.3s ease-out;
  -o-transition: 0.3s ease-out;
  transition: 0.3s ease-out;
}
.graph-buttons-switch-input:checked + .graph-buttons-switch-label-on ~ .graph-buttons-switch-selection {left: $switchWidth;}
.graph-buttons-switch-selection {
  display: block;
  position: absolute;
  z-index: 1;
  top: 0.2rem;
  left: 0.2rem;
  width: $switchWidth;
  height: 2.4rem;
  background: rgba(255, 255, 255,1);
  border-radius: 0.2rem;
  -webkit-box-shadow: inset 0 0.1rem rgba(255, 255, 255,0.6), 0 0 0.2rem rgba(0, 0, 0, 0.3);
  box-shadow: inset 0 0.1rem rgba(255, 255, 255,0.6), 0 0 0.2rem rgba(0, 0, 0, 0.3);
  -webkit-transition: left 0.3s ease-out,background 0.3s;
  -moz-transition: left 0.3s ease-out,background 0.3s;
  -o-transition: left 0.3s ease-out,background 0.3s;
  transition: left 0.3s ease-out,background 0.3s ;
/* 	transition: background 0.3s ; */
  @media screen and (max-width: 600px) {
    height: 2.2rem;
  }
}
toggle-container {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
}

/* toggle label for positioning */
.toggle-label {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  position: relative;
}

/* text styles for words on left and right */
.toggle-text {
  font-size: 16px;
  font-weight: 600;
  transition: color 0.3s ease;
  color: var(--black-soft);
}

.toggle-text.active {
  color: var(--blue-bright); /* highlighted color */
}

/* toggle input (hidden) */
.toggle-input {
  display: none;
}

/* toggle slider styles */
.toggle-slider {
  position: relative;
  width: 40px;
  height: 20px;
  background-color: lightgrey;
  border-radius: 20px;
  transition: background-color 0.3s ease;
}

.toggle-slider::before {
  content: "";
  position: absolute;
  width: 16px;
  height: 16px;
  background-color: white;
  border-radius: 50%;
  top: 2px;
  left: 2px;
  transition: transform 0.3s ease;
}

/* move slider to the right when checked */
.toggle-input:checked + .toggle-slider::before {
  transform: translateX(20px);
}

/* change slider background when checked */
.toggle-input:checked + .toggle-slider {
  background-color: var(--blue-bright);
}
</style>