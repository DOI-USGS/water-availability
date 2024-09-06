<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <p>Sources of excess nutrients in our water include   
                    <span class="highlight" id="Agriculture"> agriculture </span>,
                    <span class="highlight" id="Atmosphericdeposition"> air pollution </span>,
                    <span class="highlight" id="Wastewater"> wastewater  </span>,
                    <span class="highlight" id="Otherhumansources"> other human sources </span>, and
                    <span class="highlight" id="Naturalsources"> natural sources </span>.
                </p>
            </div>
            <div
            id="toggle-container"
            class="text-container"
            aria-hidden="true"
            >
              <p>
                <span>
                  <button
                  aria-pressed="!scalePercent" 
                  class="button"
                  :text="scaleType"
                  @click="toggleScale"
                  >
                    {{ scaleType }}
                  </button>
                </span>
              </p>

            </div>
            <div class="viz-container">
                <div id="barplot-container">    
                </div>
            </div>
            <div class="text-container">
              <p>Nutrients have a range of natural and anthropogenic sources. Natural sources of nutrients in surface water include fixation of atmospheric nitrogen by soil bacteria that is transported to streams, geogenic sources, fixation by aquatic bacteria and algae, and lightning strikes. Anthropogenic sources of nutrients in surface water generally include nonpoint fertilizer and manure application, atmospheric deposition (which generally has anthropogenic origins), nitrogen fixation by crops, and point sources such as wastewater treatment plant discharge. Legacy nitrogen stored in groundwater can also be important sources to streams as well. Across the CONUS, primary sources vary spatially, and include fertilizer and manure, atmospheric deposition, wastewater treatment plants, urban land, and a range of natural sources including stream channel and geologic sources.</p>
            </div>
        </div>



         
         <PageCarousel></PageCarousel>
    </section>
</template>

<script setup>
import { onMounted, ref, computed } from 'vue';
import * as d3 from 'd3';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import { isMobile } from 'mobile-device-detect';

// use for mobile logic
const mobileView = isMobile;
console.log(mobileView)

// Global variables 
const publicPath = import.meta.env.BASE_URL;
const dataSet1 = ref([]); 
const dataSet2 = ref([]); 
const selectedDataSet = ref('dataSet1');
const data = ref([]);
let svg;
const containerWidth = window.innerWidth * 0.8;
const containerHeight = mobileView ? window.innerHeight * 0.7 : 600;
const margin = mobileView ? { top: 60, right: 20, bottom: 20, left: 100 } : { top: 80, right: 20, bottom: 40, left: 100 };
const width = containerWidth - margin.left - margin.right;
const height = containerHeight - margin.top - margin.bottom;
console.log(containerWidth);
let chartBounds;
let rectGroup;
let categoryGroups;
let regionGroups;
let nutrientScale;
let nutrientAxis;
const scalePercent = ref(false);


// Colors for bar chart (need to be updated along with CSS below!)
const categoryColors = {
        'Agriculture': '#939185',
        'Atmospheric deposition': '#C8ACD6',
        'Other Human Sources': '#2E236C',
        'Natural sources': '#EECEB9',
        'Wastewater': '#478CCF'
      }; 



    // set up filtered chart data as computed property
    const scaleType = computed(() => {
        return scalePercent.value ? 'percent change' : 'total load'
    });
    

onMounted(async () => {
    try {
        await loadDatasets();
        data.value = selectedDataSet.value === 'dataSet1' ? dataSet1.value : dataSet2.value;
        if (data.value.length > 0) {
            // get unique categories and regions
            categoryGroups = d3.union(d3.map(data.value, d => d.category));
            regionGroups = d3.union(d3.map(data.value, d => d.region_nam));

            //console.log(regionGroups);

            initBarChart({
              containerWidth: containerWidth,
              containerHeight: containerHeight,
              margin: margin,
              width: width,
              height: height
            });
            createBarChart({
              categoryGroups: categoryGroups,
              regionGroups: regionGroups, 
              scalePercent: scalePercent.value
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

function toggleScale() {
        scalePercent.value = !scalePercent.value

        console.log(scalePercent.value + 'test')
        createBarChart({
              categoryGroups: categoryGroups,
              regionGroups: regionGroups, 
              scalePercent: scalePercent.value
    })
  }

function initBarChart({
  containerWidth,
              containerHeight,
              margin,
              width,
              height
}) {

    // draw svg canvas for barplot
    svg = d3.select('#barplot-container')
      .append('svg')
      .attr('class', 'barplotSVG')
      .attr('viewBox', `0 0 ${containerWidth} ${containerHeight}`)
      .style('width', containerWidth)
      .style('height', containerHeight);

    // add group for bar chart bounds, translating by chart margins
    chartBounds = svg.append('g')
      .attr('id', 'wrapper')
      .style("transform", `translate(${
        margin.left
      }px, ${
        margin.top
      }px)`)

    // Add group to chart bounds to hold all chart rectangle groups
    rectGroup = chartBounds.append('g')
      .attr('id', 'rectangle_group')

}
function createBarChart({
    categoryGroups,
    regionGroups,
    scalePercent
  }) {


    // stack data for rectangles
    const expressed = scalePercent ? 'percent_load' : 'load_1kMg';
    const stackedData = d3.stack()
        .keys(categoryGroups)
        .value(([, D], key) => D.get(key)[expressed]) // get value for each series key and stack
        (d3.index(data.value, d => d.region_nam, d => d.category));

    // Set up region scale (xScale in water-bottling site)
    const regionScale = d3.scaleBand()
        .domain(regionGroups)
        .range(mobileView ? [height, 0] : [0, width]); 

    // add region axis
    const regionAxis = chartBounds.append('g')
        .call(mobileView ? d3.axisLeft(regionScale) : d3.axisTop(regionScale))
        .attr('font-size', mobileView ? '1.8rem' : '2rem')
        .selectAll(".tick text")
          .call(wrap, 80);

    regionAxis
      .select(".domain").remove();

    // Set up dynamic nutrient axis (y on desktop, x on mobile)
    // scale for nutrient scale
    nutrientScale = d3.scaleLinear()
        .domain([0, d3.max(stackedData, d => d3.max(d, d => d[1]))])
        .range(mobileView ? [0, width] : [height, 0]);

    // create nutrient axis generator
    nutrientAxis = chartBounds.append('g')
        .call(mobileView ? d3.axisTop(nutrientScale) : d3.axisLeft(nutrientScale));


    chartBounds.append("g")
        .attr("class", "y-axis")
        .attr("role", "presentation")
        .attr("aria-hidden", true)


    // Set up transition.
    const dur = 1000;
    const t = d3.transition().duration(dur);

    // set up color scale
    const colorScale = d3.scaleOrdinal()
        .domain(categoryGroups)
        .range(Object.entries(categoryColors).map(([key, value]) => value));

    // Update groups for bars, assigning data
    const categoryRectGroups = rectGroup.selectAll('g')
        .data(stackedData, d => d.key)
        .attr("id", d => d.key.replace(" ", "_"))
        .join(
          enter => enter
              .append("g")
              .attr("class", d => d.key),
          
          null, // no update function

          exit => {
            exit
              .transition()
              .duration(dur / 2)
              .style("fill-opacity", 0)
              .remove();
          }
        )

    // Update bars within groups
    categoryRectGroups.selectAll('rect')
      .data(D => D.map(d => (d.key = D.key, d)))
      .join(
          enter => enter
            .append("rect")
            .attr("class", d => d.key.replace(" ", "_") + ' ' + d.data[0].replace(" ", "_"))
            .attr("role", "listitem")
            .attr('x', d => mobileView ? nutrientScale(d[0]) : regionScale(d.data[0]))
            .attr('y', d => mobileView ? regionScale(d.data[0]) : nutrientScale(d[0]))
            .attr('height', d => mobileView ? regionScale.bandwidth() : 0)
            .attr('width', d => mobileView ? 0 : regionScale.bandwidth() )
            .style("fill", d => colorScale(d.key))
          ,
          null,
          exit => {
            exit
              .transition()
              .duration(dur / 2)
              .style("fill-opacity", 0)
              .remove();
          }
        )
      //this is all after build
      .transition(t)
      .delay((d, i) => i * 20)
      .attr('x', d => mobileView ? nutrientScale(d[0]) : regionScale(d.data[0]))
      .attr('y', d => mobileView ? regionScale(d.data[0]) : nutrientScale(d[1]))
      .attr('height', d => mobileView ? regionScale.bandwidth() : nutrientScale(d[0]) - nutrientScale(d[1]))
      .attr('width', d => mobileView ? nutrientScale(d[1]) - nutrientScale(d[0]) : regionScale.bandwidth() )
      .style('fill', d => colorScale(d.key))

};

// https://gist.github.com/mbostock/7555321
function wrap(text, width) {
  text.each(function() {
    var text = d3.select(this),
    words = text.text().split(/\s|-+/).reverse(),
    word,
    line = [],
    lineNumber = 0,
    lineHeight = 0.2, // ems
    y = text.attr("y"),
    dy = parseFloat(text.attr("dy")),
    tspan = text.text(null).append("tspan").attr("x", 0).attr("y", y).attr("dy", dy + "em");
    while (word = words.pop()) {
      line.push(word);
      tspan.text(line.join(" "));
        if (tspan.node().getComputedTextLength() > width) {
        line.pop();
        tspan.text(line.join(" "));
        line = [word];
        tspan = text.append("tspan").attr("x", 0).attr("y", y).attr("dy", ++lineNumber * lineHeight + dy + "em").text(word);
        }
    }
  }
)};



</script>

<style scoped lang="scss">
#barplot-container{
  width: 80vw; /* sync with container width in js */
}
@media only screen and (max-width: 768px) {
  #barplot-container{
    width: 90vw;
  }
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

</style>