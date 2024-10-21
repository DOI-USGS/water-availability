<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <p>Water balance is the difference between how much clean water supply there is and how much water are we using. For most of the country, <span class="highlight" id="supply">water supply</span> is much higher than <span class="highlight" id="demand">water demand</span>, meaning there is more than enough water available to meet our needs. 
                  </p>
            </div>
        <div class="viz-container">
          <div id="dotplot-container">             
            <div class="toggle-container">
              <span class="highlight" id="toggle-supply">Show Supply</span>
              <span class="highlight" id="toggle-demand">Show Demand</span>
          </div>
        </div>   
        </div>
        <div class="text-container">
        <p>
          Water stress occurs when there is not enough water available to meet human and ecosystem needs. This is more likely to happen in  regions where the difference between water supply and demand is fairly small. Between 2010 and 2020, the Southern High Plains, Texas, Central High Plains, and Mississippi Embayment had the most widespread exposure to water stress in the country.
        </p>
      </div>
      <References></References>
      </div>
        <PageCarousel></PageCarousel>
    </section>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import * as d3 from 'd3';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import References from '../components/References.vue'
import { isMobile } from 'mobile-device-detect';

// use for mobile logic
const mobileView = isMobile;

// Global variables 
const publicPath = import.meta.env.BASE_URL;
const dataSet1 = ref([]); 
const data = ref([]);
let svg;
const containerWidth = window.innerWidth * 0.45;
const containerHeight = mobileView ? window.innerHeight * 0.8 : window.innerHeight * 0.5;
let margin = { top: 50, right: 50, bottom: 40, left: 200 };
let width = containerWidth - margin.left - margin.right;
let height = containerHeight - margin.top - margin.bottom;
let chartBounds, dotGroup;

let showSupply = ref(true);
let showDemand = ref(true);

const orderedRegions = ["Pacific Northwest", "Columbia-Snake", "California-Nevada", "Southwest Desert", "Central Rockies", "Northern High Plains", 
"Central High Plains", "Southern High Plains", "Texas", "Gulf Coast", "Mississippi Embayment", "Tennessee-Missouri", "Atlantic Coast", "Florida", 
"Souris-Red-Rainy","Midwest", "Great Lakes", "Northeast"]

onMounted(async () => {
    try {
        await loadDatasets();
        data.value = dataSet1.value;
        if (data.value.length > 0) {
            initDotChart();
            createDotChart();

            // Add event listeners for toggles
            d3.select("#toggle-supply").on("click", () => togglePoints("supply"));
            d3.select("#toggle-demand").on("click", () => togglePoints("demand"));
        } else {
            console.error('Error loading data');
        }
    } catch (error) {
        console.error('Error during component mounting', error);
    }
});

async function loadDatasets() {
    dataSet1.value = await loadData('wa_supply_demand.csv');
};

async function loadData(fileName) {
    try {
        const data = await d3.csv(publicPath + fileName, d => d);
        return data;
    } catch (error) {
        console.error(`Error loading data from ${fileName}`, error);
        return [];
    }
};

function initDotChart() {

  d3.select('#dotplot-container').select('svg').remove();

    svg = d3.select('#dotplot-container')
      .append('svg')
      .attr('viewBox', `0 0 ${containerWidth} ${containerHeight}`)
      .style('width', '100%')
      .style('height', 'auto');

    chartBounds = svg.append('g')
      .attr('transform', `translate(${margin.left}, ${margin.top})`);

    dotGroup = chartBounds.append('g');
}
function togglePoints(type) {
    if (type === "supply") {
        showSupply.value = !showSupply.value;
        d3.selectAll(".circle-supply").style("opacity", showSupply.value ? 1 : 0);
    } else if (type === "demand") {
        showDemand.value = !showDemand.value;
        d3.selectAll(".circle-demand").style("opacity", showDemand.value ? 1 : 0);
    }
}

function createDotChart() {
    const dataset = data.value;

    if (!dataset || dataset.length === 0) {
        console.error("No dataset available for creating the dot chart");
        return;
    }

    const yAccessor = d => d["Region_nam"];
    const xAccessorSupply = d => d["supply_mean"];
    const xAccessorDemand = d => d["demand_mean"];

    // scales
    const xScale = d3.scaleLinear()
        .domain(d3.extent(dataset, d => +d.supply_mean))
        .range([0, width-2*margin.right])
        .nice();

    const yScale = d3.scaleBand()
        .domain(dataset.map(yAccessor)) // orderedRegions for geographical order
        .range([0, height])
        .padding(0.1);

    // Remove old elements (if any) to avoid overlaps
    dotGroup.selectAll("*").remove();

    // Append axes
    dotGroup.append('g')
        .attr('class', 'x-axis')
        .attr('transform', `translate(0, ${height})`)
        .call(d3.axisBottom(xScale).ticks(5));

    dotGroup.append('g')
        .attr('class', 'x-axis')
        .call(d3.axisTop(xScale).ticks(5));

    dotGroup.append('g')
        .attr('class', 'y-axis')
        .call(d3.axisLeft(yScale));

    // adding maps
    const regionAxis = dotGroup.select('.y-axis')
      .selectAll(".tick")
      .select("text")
      .attr("x", -44) // shift text to the left to make space for the mini maps
      .attr("dy", "0.32em");

      // load SVG and add it to each tick
      d3.xml(`${import.meta.env.BASE_URL}assets/USregions.svg`).then(function(xml) {
      const svgNode = xml.documentElement;

      dotGroup.select('.y-axis')
      .selectAll(".tick")
        .each(function(d) {
          const regionClass = d.replace(/\s+/g, '_'); 

          // the mini map to use for each tick
          const svgClone = svgNode.cloneNode(true);

          // add the map at each tick
          const insertedSvg = d3.select(this)
            .insert(() => svgClone, "text") 
            .attr("x", -40) 
            .attr("y", -20) 
            .attr("width", 40) 
            .attr("height", 40)
            .attr("fill", "lightgrey"); 

          // select the <g> element with the region name
          insertedSvg.selectAll(`g.${regionClass} path`) // grab the path
            .attr("stroke", "black") // apply black outline
            .attr("stroke-width", 3)
            .attr("fill", "black"); 
        });
    }); 
    
    // axis label
    dotGroup.append("text")
      .attr("class", "upper-right-label")
      .attr("x", width - 2*margin.right) 
      .attr("y", -30)
      .attr("text-anchor", "end") // anchor to the end of the text
      .style("font-size", "2rem")
      .style("font-weight", "bold")
      .text("Units");

    // Add dots and lines
    dotGroup.selectAll(".line")
        .data(dataset)
        .enter().append('line')
        .attr('x1', d => xScale(d.supply_mean))
        .attr('x2', d => xScale(d.demand_mean))
        .attr('y1', d => yScale(d.Region_nam) + yScale.bandwidth() / 2)
        .attr('y2', d => yScale(d.Region_nam) + yScale.bandwidth() / 2)
        .attr('stroke', '#ccc')
        .attr('stroke-width', 3)
        .attr("stroke-opacity", 0.4);

    dotGroup.selectAll(".circle-supply")
        .data(dataset)
        .enter().append('circle')
        .attr('cx', d => xScale(d.supply_mean))
        .attr('cy', d => yScale(d.Region_nam) + yScale.bandwidth() / 2)
        .attr('r', 5)
        .attr('fill', '#669999');

    dotGroup.selectAll(".circle-demand")
        .data(dataset)
        .enter().append('circle')
        .attr('cx', d => xScale(d.demand_mean))
        .attr('cy', d => yScale(d.Region_nam) + yScale.bandwidth() / 2)
        .attr('r', 5)
        .attr('fill', '#F87A53');
}



</script>

<style scoped>
.content-container {
  display: block;
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
#toggle-supply, #toggle-demand {
  margin-left: 10px;
  background-color: #669999;
}

#toggle-demand {
  background-color: #F87A53;
}

.toggle-container {
  display: inline-block;
  margin-top: -30px;
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
    background-color: #669999;
  }

  &#demand {
    background-color: #F87A53;
  }

}
</style>