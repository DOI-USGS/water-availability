<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">

            <div  class="text-container">
              <h2>Surface water quality contamination</h2>
              <p>Surface water quality differs by source and use. Broad sources of water contamination include   
                    <span class="highlight" id="Biotic"> biotic threats </span>,
                    <span class="highlight" id="Nutrients"> nutrients </span>,
                    <span class="highlight" id="Organics"> organics  </span>,
                    <span class="highlight" id="Metals"> metals </span>, 
                    <span class="highlight" id="Sediment"> sediment </span>, 
                    <span class="highlight" id="Salinity"> salinity </span>, and
                    <span class="highlight" id="Temperature"> temperature </span>. Some areas of surface water are not threatened and are considered
                    <span class="highlight" id="Unimpaired"> unimpaired </span>. The charts below show threats to the quality of surface water in the U.S. by source and water-use category. The height of each ribbon in the chart represents the total river miles impaired or unimpaired, and the broad categories on the left are broken out into their respective threats on the right. 
                </p>
            </div>
            <div class="viz-container">
              <tabsGroup class="tab-group" :options="{ useUrlFragment: false }">
                <tabItem 
                name="Drinking water"
                :prefix="getIconImgHTML('dw')">
                  <div class="tab-container-text-d3">
                    <h3 class="tab-content-title">
                          About one-third of stream miles that are sources of drinking-water supply are impaired for drinking-water use, most commonly because of non-mercury metals and salinity. 
                    </h3>
                    <div class="tab-content-d3">
                      <section id="DW-container" ref="chart"></section>
                    </div>
                    <div class="tab-content-text">
                      <p>Iron, selenium, arsenic, lead, and copper are the top non-mercury metals impairing rivers and streams across the United States (US EPA, 2023). These types of metals occur naturally in surface water from geogenic sources such as rock weathering and soil erosion. Human activities like mining, urban runoff, wastewater, fertilizer and pesticide use, fuel combustion, and nuclear reactions can also add substantial volumes of metals to the environment above background levels. Human-derived metals may also be released in more toxic and mobile forms than natural sources (Vareda et al., 2019).</p>
                      <br>
                      <p>Salinity effects on water availability are more spatially limited than metals, but salinity can cause considerable local issues for human beneficial uses and ecosystem needs. There has been a growing recognition of the threat that salinization (increasing salinity) of surface waters poses to water availability (Cañedo-Argüelles, 2020). Over one-third of the drainage area of the lower 48 states has experienced salinization, primarily in the populated Northeast through Midwest aggregated hydrologic regions (Kaushal et al., 2018; Cañedo-Argüelles, 2020). Trend assessments at many sites across the United States show increasing salinity over time, particularly in urban areas, and at concentrations that indicate potential corrosion of drinking-water infrastructure (Stets et al. 2020).</p>
                    </div>
                  </div>
                </tabItem>
                <tabItem 
                name="Fish consumption"
                :prefix="getIconImgHTML('fish')">
                  <div class="tab-container-text-d3">
                    <h3 class="tab-content-title">
                    Water-quality problems that affect ecosystems may also affect people who rely on ecosystems for food. The top threats to fish consumption for human health include mercury and polychlorinated biphenyls (PCBs). 
                    </h3>
                    <div class="tab-content-d3">
                      <section id="fish-container" ref="chart"></section>
                    </div>
                    <div class="tab-content-text">
                      <p>Communities that rely on fishing for a larger proportion of their dietary intake can be particularly vulnerable to the effects of limited water availability on ecosystems and fish communities. Financial insecurity may increase the dependence on fishing to meet caloric needs, and transportation barriers can limit access to alternative fishing locations or food sources. Remote communities in particular are more likely to use subsistence fishing for their diet (Gillespie et al., 2018). American Indian and Arctic Native communities have a high dependence on wild-caught fish and are more likely to experience health effects from mercury pollution (Arctic Monitoring and Assessment Programme, 2009). Low-income populations and those with English as a second language can also be particularly vulnerable to contaminated fish from heavy metals, organics, and other factors because of communication barriers reducing the effectiveness of fish-consumption advisories (Bruce Lauber et al., 2017). </p>
                      <br>
                      <p>Mercury can harm aquatic organisms and limit the amount of fish and other aquatic species that are safe for humans to eat. Mercury has geogenic sources (volcanoes, hot springs, geologic deposits, and the ocean) and anthropogenic sources (industrial processes, mining, and coal combustion). Dispersion of mercury through the atmosphere has resulted in widespread occurrence of mercury in the environment. The methylated form of mercury is highly bioavailable—meaning it can be absorbed in the body—and can accumulate in fish higher in the food chain, like tuna, at concentrations that make fish consumption unhealthy for humans (Wentz et al., 2014). Young children and developing fetuses are particularly vulnerable to mercury exposure. </p>
                      <br>
                      <p>PCBs are endocrine-disrupting compounds that were once commonly used in industry and commercial products and are associated a wide range of human-health risks. PCBs are generally stable and persistent in the environment and can bioaccumulate in aquatic organisms and food webs (Ngoubeyou et al., 2022), leading to concerns for ecological and recreational uses and hazards to human health through fish consumption. Although PCBs were prohibited decades ago, PCB contamination can be common in industrial sites and hydrologically connected locations About 30 of the historical worldwide production of PCBs is still present in aquatic ecosystems, sediments, and aquatic food webs (Ngoubeyou et al., 2022).</p>
                    </div>
                  </div>
                </tabItem>
                <tabItem 
                name="Recreation"
                :prefix="getIconImgHTML('rec')">
                  <div class="tab-container-text-d3">
                    <h3 class="tab-content-title">
                      Biotic pathogens are the main threat to recreational use of surface water in the United States. 
                    </h3>
                    <div class="tab-content-d3">
                      <section id="rec-container" ref="chart"></section>
                    </div>
                    <div class="tab-content-text">
                      <p>Microbial pathogens, especially bacteria (U.S. Environmental Protection Agency, 2023c), primarily threaten human health through ingestion and recreational activities like swimming. Bacteria can originate from natural or human activities that cause contamination including wastewater treatment plant discharge, leaky septic systems, stormwater runoff, animal waste, and runoff from animal pastures, feedlots, or manure storage (Cabral, 2010; Verhougstraete et al., 2015; U.S. Environmental Protection Agency, 2020). Each year in the United States, an estimated 560,000 people suffer from moderate-to-severe waterborne infection. An additional 1.7 million people suffer from mild-to-moderate waterborne infections, and an estimated 1,200 people die from waterborne infections (Morris and Levine, 1995). Young children are particularly vulnerable to waterborne diseases.</p>
                    </div>
                  </div>
                </tabItem>
              </tabsGroup>
            </div>
            <div  class="text-container">
              <h2>Groundwater quality contamination</h2>
              <p>The contaminants that are most commonly found at elevated or high-concentration in drinking-water aquifers are "geogenic," or sourced from geologic sources like bedrock. Elevated geogenic constituent concentrations affect more than 30 million people. Five geogenic constituents (arsenic, manganese, strontium, radium, and radionuclides) each have a substantially larger area and larger population affected by elevated concentration than nitrate. The largest affected groundwater-dependent populations rely on three aquifers: the California Coastal Basin, Basin and Range basin-fill, and the Glacial aquifer (Belitz and others, 2022).</p>
              <br>
              <p>These pie charts represent the overall groundwater quality in principal aquifers across the U.S. The charts show the percentage of the area of the aquifer that contained a contaminant in untreated groundwater samples at a <span class="highlight" id="high"> high</span>, <span class="highlight" id="moderate"> moderate</span> or <span class="highlight" id="low"> low </span> concentration relative to human-health benchmarks for drinking water. 
                </p>
            </div>
            <div class="viz-container">
              <img class="viz-placeholder" src="../assets/images/R/06_wq_gw_geofacet.png">
            </div>
              <Methods></Methods>
              <References></References>
        </div>
      <!-- conditionally render PageCarousel for preview site -->
      <PageCarousel v-if="featureToggles.showPageCarousel"></PageCarousel>
    </section>


</template>

<script setup>
import { onMounted, ref, inject } from 'vue';
import * as d3 from 'd3';
import * as d3sankey from 'd3-sankey';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import Methods from '../components/Methods.vue';
import References from '../components/References.vue';
import { isMobile } from 'mobile-device-detect';
import { text } from '@fortawesome/fontawesome-svg-core';


const featureToggles = inject('featureToggles');



// use for mobile logic
const mobileView = isMobile;


// global objects
const baseURL = "https://labs.waterdata.usgs.gov/visualizations/images/water-availability/"



// Global variables 
const publicPath = import.meta.env.BASE_URL;
const datasetAll = ref([]);
const datasetDW = ref([]);
const datasetFish = ref([]);
const datasetEco = ref([]);
const datasetOther = ref([]);
const datasetRec = ref([]);
const data = ref([]);
let svg;
const chart = ref(null);
let chartDimensions;
const nodeWidth = 4;
const nodePadding = mobileView ? 24 : 20; // Increase node spacing for mobile
const labelBuffer = 10;
let chartBounds;
let nodeGroup;
let linkGroup;
let textGroup;

// Abbreviations
//  DW = Drinking Water Use
//  Eco = Ecological Use
//  Fish = Fish Consumption Use
//  Rec = Recreational Use
//  Other = Other Use

// functions for tabs

function getIconURL(suffix) {
    return baseURL + `06_icon_${suffix}.png`
}
function getIconImgHTML(image_name) {
    const imgURL = getIconURL(image_name);
    return `<img class='tab-image' src=${imgURL}>`
}

// Colors for threat categories, Needs to be updated with CSS for text legend
const categoryColors = {
  'Biotic': '#EECEB9',
  'Nutrients':  '#939185',
  'Organics':  '#C8ACD6', 
  'Metals':  '#80909D',
  'Sediment': '#E8E8E3',
  'Salinity': '#F3C623',
  'Temperature': '#FFB0B0',
  'Unimpaired': '#478CCF',
}; 



onMounted(async () => {
    try {
        await loadDatasets();
        
        data.value = datasetDW.value;
        if (data.value.length > 0) {
            // set up chart dimensions
            chartDimensions = {
                width: chart.value.offsetWidth,
                height: mobileView ? window.innerHeight : window.innerHeight * 0.7,
                margin: {
                    top: mobileView ? 60 : 50,
                    right: mobileView ? 145 : 200,
                    bottom: mobileView ? 15 : 10,
                    left: mobileView ? 0 : 170
                },
            }
            chartDimensions.boundedWidth = chartDimensions.width - chartDimensions.margin.left - chartDimensions.margin.right,
            chartDimensions.boundedHeight = chartDimensions.height - chartDimensions.margin.top - chartDimensions.margin.bottom

            // build charts
            initSankey({
              containerId: 'DW-container'
            });
            createSankey({
              dataset: datasetDW.value,
            });
            initSankey({
              containerId: 'fish-container'
            });
            createSankey({
              dataset: datasetFish.value,
            });
            initSankey({
              containerId: 'rec-container'
            });
            createSankey({
              dataset: datasetRec.value,
            });

        } else {
            console.error('Error loading data');
        }
    } catch (error) {
        console.error('Error during component mounting', error);
    }
});

async function loadDatasets() { // Created from R pipeline
  try {
    datasetAll.value = await loadData('wq_threats_all.csv');
    datasetDW.value = await loadData('wq_threats_DW.csv');
    datasetEco.value = await loadData('wq_threats_Eco.csv');
    datasetRec.value = await loadData('wq_threats_Rec.csv');
    datasetFish.value = await loadData('wq_threats_Fish.csv');
    datasetOther.value = await loadData('wq_threats_Other.csv');
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

function initSankey({
        containerId
    }) {

    // draw svg canvas for sankey
    svg = d3.select('#' + containerId)
      .append('svg')
      .attr('class', 'sankeySVG')
      .attr('viewBox', `0 0 ${chartDimensions.width} ${chartDimensions.height}`)
      .style('width', '100%')
      .style('height', '100%');

    // add group for bar chart bounds, translating by chart margins
    chartBounds = svg.append('g')
      .attr('id', 'wrapper')
      .style("transform", `translate(${
        chartDimensions.margin.left
      }px, ${
        chartDimensions.margin.top
      }px)`)

    // Add group to chart bounds to hold all sankey path groups
    nodeGroup = chartBounds.append('g')
      .attr('id', 'node_group')
    
    linkGroup = chartBounds.append('g')
      .attr('id', 'link_group')

    textGroup = chartBounds.append('g')
      .attr('id', 'text_group')

    // add titles
    const leftTitle = svg.append("text")
      .attr("class", "axis-title")
      .attr("x", chartDimensions.margin.left - labelBuffer + nodeWidth) // match spacing between sankey and labels
      .attr("y", 0)
      .attr("dx", "0em")
      .attr("dy", "0em")
      .attr("data-width", chartDimensions.margin.left)
      .attr("dominant-baseline", "text-before-edge")
      .attr("text-anchor", "end")
      .text("Threat Categories")
      .call(d => mobileView ? wrap(d, {shift: false}) : d)

    const leftTitleLength = leftTitle.node().getComputedTextLength()

    svg.append("text")
      .attr("class", "axis-text axis-value")
      .attr("x", chartDimensions.margin.left - labelBuffer + nodeWidth) // match spacing between sankey and labels
      .attr("y", 0)
      .attr("dx", "0em")
      .attr("dy", leftTitleLength > chartDimensions.margin.left ? "2.2em" : "1.1em")
      .attr("data-width", chartDimensions.margin.left)
      .attr("dominant-baseline", "text-before-edge")
      .attr("text-anchor", "end")
      .text("River miles")
      .call(d => mobileView ? wrap(d, {shift: false}) : d)

    svg.append("text")
      .attr("class", "axis-title")
      .attr("x", chartDimensions.width - chartDimensions.margin.right + labelBuffer - nodeWidth) // match spacing between sankey and labels
      .attr("y", 0)
      .attr("dx", "0em")
      .attr("dy", "0em")
      .attr("data-width", chartDimensions.margin.right)
      .attr("dominant-baseline", "text-before-edge")
      .attr("text-anchor", "start")
      .text("Threats")

    svg.append("text")
      .attr("class", "axis-text axis-value")
      .attr("x", chartDimensions.width - chartDimensions.margin.right + labelBuffer - nodeWidth) // match spacing between sankey and labels
      .attr("y", 0)
      .attr("dx", "0em")
      .attr("dy", "1.1em")
      .attr("data-width", chartDimensions.margin.right)
      .attr("dominant-baseline", "text-before-edge")
      .attr("text-anchor", "start")
      .text("River miles")
      .call(d => mobileView ? wrap(d, {shift: false}) : d)

};

function createSankey({
    dataset
  }) {

    // get unique categories and parameters
    const categoryGroups = [... new Set(dataset.map(d => d.Category))];
    
    // initialize sankey
    const sankey = d3sankey.sankey()
      .nodeWidth(nodeWidth)
      .nodePadding(nodePadding) // Increase padding on mobile
      .nodeSort((a,b) => d3.descending(a.value, b.value))
      .extent([[0, 0], [chartDimensions.boundedWidth, chartDimensions.boundedHeight]])

    // Set up color scale 
    const colorScale = d3.scaleOrdinal()
        .domain(categoryGroups)
        .range(Object.values(categoryGroups.map(item => categoryColors[item])));

    // set up the nodes and links
    var nodesLinks = graphNodes({
      data: dataset
    });

    const {nodes, links} = sankey({
      nodes: nodesLinks.nodes.map(d => Object.create(d)),
      links: nodesLinks.links.map(d => Object.create(d))
    });

    // Set up transition.
    const dur = 1000;

    // Update nodes for sankey, assigning data
    nodeGroup.selectAll('g')
      .data(nodes)
      .join(
        enter => enter
          .append('rect')
            .attr("x", d => d.x0)
            .attr("y", d => d.y0)
            .attr("height", d => d.y1 - d.y0)
            .attr("width", d => d.x1 - d.x0)
          .append("title")
            .text(d => `${d.name}\n${d.value.toLocaleString()}`),

          null, // no update function

          exit => {
            exit
              .transition()
              .duration(dur / 2)
              .style("fill-opacity", 0)
              .remove();
      });

    // Update links for sankey, assigning data
    linkGroup.selectAll('g')
      .data(links)
      .join(
        enter => {
          enter 
            .append("path")
              .attr("d", d3sankey.sankeyLinkHorizontal())
              .attr("stroke", d => colorScale(d.names[0]))
              .attr("stroke-width", d => mobileView ? d.width + 1 : d.width + 0.5) // add buffer so we never lose the lines, even on mobile
              .style("mix-blend-mode", "multiply")
              .style('fill', "none")
            .append("title")
              .text(d => `${d.names.join(" → ")}\n${d.value.toLocaleString()}`)
        },

        null,

        exit => {
          exit
            .transition()
            .duration(dur / 2)
            .style("fill-opacity", 0)
            .style("stroke-width", 0)
            .style("color-opacity", 0)
            .remove();
        }
      );


    // Update text for sankey, assigning data from nodes
    const wrapBuffer = 5;
    textGroup.selectAll('g')
      .data(nodes)
      .join(
        enter => {
          const textEnter = enter
            .append("text")
            .attr("class", "axis-text")
            .attr("x", d => d.x0 < chartDimensions.boundedWidth / 2 ? d.x1 : d.x0)  // Push left-side labels inside SVG bounds
            .attr("y", d => (d.y1 + d.y0) / 2)
            .attr("dominant-baseline", "central")
            .attr("dy", "0em")
            .attr("dx", d => d.x0 < chartDimensions.boundedWidth / 2 ? -labelBuffer : labelBuffer)
            .attr("text-anchor", d => d.x0 < chartDimensions.boundedWidth / 2 ? "end" : "start")  // Left-side labels aligned to the end
            .attr("data-width", d => d.x0 < chartDimensions.boundedWidth / 2 ? chartDimensions.margin.left - wrapBuffer : chartDimensions.margin.right - wrapBuffer)

          // Add label name
          textEnter
            .append("tspan")
            .text(d => d.name);

          // Add label value
          textEnter
            .append("tspan")
            .attr("class", "axis-value")
            .text(d => ` ${d.value.toLocaleString()}`);

          // wrap labels on mobile
          if (mobileView) {              
            textEnter
              .call(d => wrap(d, {shift: true}));
          }
        }
      );

};

// set up the nodes and links
function graphNodes({data}){ //https://observablehq.com/@d3/parallel-sets?collection=@d3/d3-sankey
  let keys = data.columns.slice(1, -2); // which columns for nodes
  // columns are: Use, Category, Parameter, riverMiles, UseAbbr (from R pipeline)
  let index = -1;
  let nodes = [];
  let nodeByKey = new d3.InternMap([], JSON.stringify);
  let indexByKey = new d3.InternMap([], JSON.stringify);
  let links = [];


  // creates nodes for each column (keys)
  for (const k of keys) {
    for (const d of data) {
      const key = [k, d[k]];
      if (nodeByKey.has(key)) continue;
        const node = {name: d[k]};
        nodes.push(node);
        nodeByKey.set(key, node);
        indexByKey.set(key, ++index);
    }
  }
  
  
  // creates links between nodes
  for (let i = 1; i < keys.length; ++i) {
    const a = keys[i - 1];
    const b = keys[i];
    const prefix = keys.slice(0, i + 1);
    const linkByKey = new d3.InternMap([], JSON.stringify);
    for (const d of data) {
      const names = prefix.map(k => d[k]);
      const value = d.riverMiles; 
      let link = linkByKey.get(names);
      if (link) { link.value += value; continue; }
      link = {
        source: indexByKey.get([a, d[a]]),
        target: indexByKey.get([b, d[b]]),
        names,
        value
      };
      links.push(link);
      linkByKey.set(names, link);
    }
  }
  return {nodes, links};
};

// https://gist.github.com/mbostock/7555321
function wrap(text, {
  shift = true
}) {
    text.each(function() {
        var text = d3.select(this),
        words = text.text().split(/\s|-+/).reverse(),
        word,
        line = [],
        lineNumber = 0,
        lineHeight = 0.95, // ems
        width = text.attr("data-width"),
        x = text.attr("x"),
        y = text.attr("y"),
        dy = parseFloat(text.attr("dy")),
        dx = parseFloat(text.attr("dx")),
        tspan = text.text(null).append("tspan").attr("y", y).attr("dy", dy + "em");

        while ((word = words.pop())) {
          const wordIsNumber = !isNaN(Number(word.replace(/,/g,'')))
          let tspanClass = wordIsNumber ? 'axis-value' : ''
          line.push(word);
          tspan.text(line.join(" "));
          if (tspan.node().getComputedTextLength() > width) {
            line.pop();
            tspan.text(line.join(" "));
            line = [word];
            tspan = text.append("tspan").attr("class", tspanClass).attr("x", x).attr("y", y).attr("dx", dx).attr("dy", ++lineNumber * lineHeight + dy + "em").text(word);
          } else if (tspan.node().getComputedTextLength() < width && wordIsNumber) {
            line.pop();
            tspan.text(line.join(" "));
            line = [word];
            tspan = text.append("tspan").attr("class", tspanClass).text(' ' + word);
          }
        }

        // https://stackoverflow.com/questions/60558291/wrapping-and-vertically-centering-text-using-d3-js
        if (lineNumber > 0 && shift) {
            const startDy = -(lineNumber * (lineHeight / 2));
            text
                .selectAll("tspan")
                .attr("dy", (d, i) => startDy + lineHeight * i + "em");
        }
    }
)};

// Commenting this out b/c it's not functioning as intended
// The dimension variables reference here are constant
// Also, as written, it appends a new svg on resize
// window.addEventListener('resize', () => {
//   containerWidth = window.innerWidth * 0.8;
//   containerHeight = mobileView ? window.innerHeight * 0.9 : 600;
//   width = containerWidth - margin.left - margin.right;
//   height = containerHeight - margin.top - margin.bottom;
//   // Update the chart
//   initSankey({ containerWidth, containerHeight, margin, width, height, containerId: 'DW-container' });
//   createSankey({ dataset: datasetDW.value, containerId: 'DW-container' });
// });



</script>

<style scoped>
.viz-container {
  width: 100%;
  overflow: hidden;
  display: flex;
  justify-content: center; /* Center align the chart */
  margin-top: 2rem;
}

#DW-container, #fish-container, #rec-container {
  width: 100%;
  height: 100%;
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

  &#Biotic {
    background-color: #EECEB9;
  }

  &#Nutrients {
    background-color: #939185;
  }

  &#Organics {
    background-color: #C8ACD6;
  }

  &#Metals {
    background-color: #80909D;
  }

  &#Sediment {
    background-color: #E8E8E3;
  }

  &#Salinity {
    background-color: #F3C623;
  }

  &#Temperature {
    background-color: #FFB0B0;
  }

  &#Unimpaired {
    background-color: #478CCF;
  }

  &#high {
    background-color: #3B1E54;
    color: white;
  }

  &#moderate {
    background-color: #8F6EB4;
    color: white;
  }

  &#low {
    background-color: #E7D9F2;
  }
}

.sankey-container {
  width: 80%;
  min-width: 600px;
  margin: 0 auto;
  padding-top: 20px;
}
@media only screen and (max-width: 768px) {
  .sankey-container {
    width: 90%;
    min-width: 200px;
  }
}
.sankey-tab-container {
  width: 90%;
  margin: 0 auto;
}

</style>
<style lang="scss">
  .axis-value {
    fill-opacity: 0.7;
  }
</style>