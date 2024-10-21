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
              <button
                :class="{'active-toggle': showDemand, 'inactive-toggle': !showDemand}"
                @click="togglePoints('demand')"
                class="highlight demand toggle-button"
              >
                {{ showDemand ? 'Hide Demand' : 'Show Demand' }}
              </button>
              <button
            :class="{'active-toggle': showSupply, 'inactive-toggle': !showSupply}"
            @click="togglePoints('supply')"
            class="highlight supply toggle-button"
          >
            {{ showSupply ? 'Hide Supply' : 'Show Supply' }}
          </button>
          </div>
        </div>   
        </div>
        <div class="text-container">
        <p>
          Water stress occurs when there is not enough water available to meet human and ecosystem needs. This is more likely to happen in  regions where the difference between water supply and demand is fairly small. Between 2010 and 2020, the Southern High Plains, Texas, Central High Plains, and Mississippi Embayment had the most widespread exposure to water stress in the country.
        </p>
        </div>
        <div class="image-container">
            <img src="../../public/images/01stress_map.png" alt="Water Stress" class="background-image">
            <!-- Overlay SVG with the same dimensions -->
            <svg class="overlay-svg"></svg>
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
import References from '../components/References.vue';
import { isMobile } from 'mobile-device-detect';

const mobileView = isMobile;

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
let xScale;
let originalXScaleDomain;

let showSupply = ref(true);
let showDemand = ref(true);

const orderedRegions = [
    "Pacific Northwest", "Columbia-Snake", "California-Nevada", "Southwest Desert", "Central Rockies", "Northern High Plains", 
    "Central High Plains", "Southern High Plains", "Texas", "Gulf Coast", "Mississippi Embayment", "Tennessee-Missouri", "Atlantic Coast", 
    "Florida", "Souris-Red-Rainy", "Midwest", "Great Lakes", "Northeast"
];

onMounted(async () => {
    try {
      // Load and append the external SVG to the overlay
      d3.xml(`${publicPath}assets/USregions.svg`).then(function(xml) {
            const svgNode = xml.documentElement;

            svgNode.setAttribute("width", "113%"); // Adjust as needed
            svgNode.setAttribute("height", "auto")
            svgNode.setAttribute("x", "37")
            svgNode.setAttribute("y", "-2"); 

            // Append the loaded SVG into the overlay-svg container
            const overlaySvg = d3.select(".overlay-svg")
              .node().appendChild(svgNode); 

            d3.select(svgNode).selectAll("g path")
              .attr("stroke", "white")
              .attr("stroke-width", "1.5")
              .attr("fill", "transparent")
              .on("mouseover", function(event, d) {
                d3.selectAll(this).raise(); // Move the path to the front
                d3.select(this)
                  .attr("stroke", "yellow") 
                  .attr("stroke-width", "3");

                // Show region name near the cursor
                d3.select(".overlay-svg").append("text")
                  .attr("class", "region-label")
                  .attr("x", event.pageX + 10) // Position near the cursor
                  .attr("y", event.pageY - 10)
                  .text(d3.select(this).attr("id")); 
              })
              .on("mousemove", function(event) {
                // Update the position of the label as the mouse moves
                d3.select(".region-label")
                  .attr("x", event.pageX + 10)
                  .attr("y", event.pageY - 10);
              })
              .on("mouseout", function() {
                d3.select(this)
                  .attr("stroke", "white") // Reset to original color
                  .attr("stroke-width", "1.5");

                // Remove the region label
                d3.select(".region-label").remove();
              });
      })
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
            .attr("fill", "lightgrey");

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
        .attr('fill', '#669999');

    dotGroup.selectAll(".circle-demand")
        .data(dataset)
        .enter().append('circle')
        .attr('class', 'circle-demand')
        .attr('cx', d => xScale(d.demand_mean))
        .attr('cy', d => yScale(d.Region_nam) + yScale.bandwidth() / 2)
        .attr('r', 5)
        .attr('fill', '#F87A53');
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
  width: 95%; 
  max-width: 800px;
  margin: 40px auto; 
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


#toggle-supply, #toggle-demand {
  margin-left: 10px;
  background-color: #669999;
}

#toggle-demand {
  background-color: #F87A53;
}

.toggle-container {
  display: flex;
  width: 300px;
  margin-top: 20px;
  margin: auto;
  margin-bottom: 40px;
  align-items: center;
  justify-content: center;
  z-index: 999;
  button {
    padding: 2px;
    margin: 5px;
    text-align: center;
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

  &#supply {
    background-color: #669999;
  }

  &#demand {
    background-color: #F87A53;
  }

}
.supply {
  background-color: #669999;
}

.demand {
  background-color: #F87A53;
}
.inactive-toggle {
  background-color: lightgrey; 
  color: black;
}
</style>