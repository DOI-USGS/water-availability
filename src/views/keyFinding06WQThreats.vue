<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <p>Most Americans are provided with drinking water from public supplies. Low-income and minority-dominated communities and people with domestic wells as their drinking water source experience increased exposure to drinking water contamination. </p>
            </div>
            <div
            id="toggle-container"
            class="text-container"
            aria-hidden="true"
            >
              <p>This chart shows threats to the water quality of surface water in the U.S. by source and water use category. Sources include   
                    <span class="highlight" id="Biotic"> biotic threats </span>,
                    <span class="highlight" id="Nutrients"> nutrients </span>,
                    <span class="highlight" id="Organics"> organics  </span>,
                    <span class="highlight" id="Metals"> metal and physical sources </span>, 
                    <span class="highlight" id="Sediment"> sediment </span>, 
                    <span class="highlight" id="Salinity"> salinity </span>, and
                    <span class="highlight" id="Temperature"> temperature </span>. Some areas of surface water are not threatened and are considered
                    <span class="highlight" id="Unimpaired"> unimpaired </span>.
                </p>
            </div>
            <section id="dw-viz">
              <div class="text-container">
                <h2>Top Threats to Drinking Water</h2>
                <p>Most Americans are provided with drinking water from public supplies. Metal contamination, salinity, and sediments were identified as the main threats to streams and rivers used as a drinking-water source. Low-income and minority-dominated communities and people with domestic wells as their drinking water source experience increased exposure to drinking water contamination.</p>
              </div>
              <div class="viz-container">
                <div id="DW-container">    
                </div>
              </div>
            </section>
            <section id="fish-viz">
              <div class="text-container">
                <h2>Top Threats to Fish Consumption</h2>
                <p>Stream contaminants that threaten fish-consumption use by humans included primarily polychlorinated biphenyls and mercury.</p>
              </div>
              <div class="viz-container">
                <div id="fish-container">    
                </div>
              </div>
            </section>
              <section id="rec-viz">
                <div class="text-container">
                  <h2>Top Threats to Recreational Water Use</h2>
                  <p>Contaminants that threaten recreational use were mainly biotic pathogens.</p>
                </div>
                <div class="viz-container">
                  <div id="rec-container">    
                  </div>
                </div>
              </section>
        </div>
        <PageCarousel></PageCarousel>
    </section>
</template>

<script setup>
import { onMounted, ref, computed } from 'vue';
import * as d3 from 'd3';
import * as d3sankey from 'd3-sankey';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';
import { isMobile } from 'mobile-device-detect';
import { color } from 'd3';

// use for mobile logic
const mobileView = isMobile;

// Global variables 
const publicPath = import.meta.env.BASE_URL;
const datasetAll = ref([]);
const datasetDW = ref([]);
const datasetFish = ref([]);
const datasetEco = ref([]);
const datasetOther = ref([]);
const datasetRec = ref([]);
const selectedDataset = ref('datasetAll');
const data = ref([]);
let svg;
const containerWidth = window.innerWidth * 0.8;
const containerHeight = mobileView ? window.innerHeight * 0.7 : 600;
const margin = mobileView ? { top: 60, right: 20, bottom: 20, left: 100 } : { top: 80, right: 20, bottom: 40, left: 100 };
const width = containerWidth - margin.left - margin.right;
const height = containerHeight - margin.top - margin.bottom;
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

// Colors for threat categories, Needs to be updated with CSS for text legend
const categoryColors = {
  'Biotic': '#EECEB9',
  'Nutrients':  '#939185',
  'Organics':  '#C8ACD6', 
  'Metals and Physical':  '#80909D',
  'Sediment': '#E8E8E3',
  'Salinity': '#F3C623',
  'Temp': '#FFB0B0',
  'Unimpaired': '#478CCF',
}; 



onMounted(async () => {
    try {
        await loadDatasets();
        
        data.value = datasetDW.value;
        if (data.value.length > 0) {
            initSankey({
              containerWidth: containerWidth,
              containerHeight: containerHeight,
              margin: margin,
              width: width,
              height: height,
              containerId: 'DW-container'
            });
            createSankey({
              dataset: datasetDW.value,
              containerId: 'DW-container'
            });
            initSankey({
              containerWidth: containerWidth,
              containerHeight: containerHeight,
              margin: margin,
              width: width,
              height: height,
              containerId: 'fish-container'
            });
            createSankey({
              dataset: datasetFish.value,
              containerId: 'fish-container'
            });
            initSankey({
              containerWidth: containerWidth,
              containerHeight: containerHeight,
              margin: margin,
              width: width,
              height: height,
              containerId: 'rec-container'
            });
            createSankey({
              dataset: datasetRec.value,
              containerId: 'rec-container'
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
        containerWidth,
        containerHeight,
        margin,
        containerId
    }) {

    // draw svg canvas for sankey
    svg = d3.select('#' + containerId)
      .append('svg')
      .attr('class', 'sankeySVG')
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

    // Add group to chart bounds to hold all sankey path groups
    nodeGroup = chartBounds.append('g')
      .attr('id', 'node_group')
    
    linkGroup = chartBounds.append('g')
      .attr('id', 'link_group')

    textGroup = chartBounds.append('g')
      .attr('id', 'text_group')
    

};

function createSankey({
    dataset,
    containerId
  }) {

    // get unique categories and parameters
    const categoryGroups = d3.union(d3.map(dataset, d => d.Category));
    const parameterGroups = d3.union(d3.map(dataset, d => d.Parameter));
    
    // initialize sankey
    const sankey = d3sankey.sankey()
        .nodeSort(null)
        .linkSort(null)
        .nodeWidth(4)
        .nodePadding(11)
        .extent([[150, 5], [width - 300, height - 0]])

    // Set up color scale 
    const colorScale = d3.scaleOrdinal()
        .domain(categoryGroups)
        .range(Object.values(categoryColors));

    
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
    const t = d3.transition().duration(dur);

    console.log(nodes)

    // Update nodes for sankey, assigning data
    const sankeyNodesGroups = nodeGroup.selectAll('g')
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
    const sankeyLinksGroups = linkGroup.selectAll('g')
      .data(links)
      .join(
        enter => {
          enter 
            .append("path")
              .attr("d", d3sankey.sankeyLinkHorizontal())
              .attr("stroke", d => colorScale(d.names[0]))
              .attr("stroke-width", d => d.width)
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
    const sankeyTextGroups = textGroup.selectAll('g')
          .data(nodes)
          .join(
            enter => {
              enter
              .append("text")
                .attr("x", d => d.x0 < width / 2 ? d.x1 -10 : d.x0 + 10) //checks for right-most labels
                .attr("y", d => (d.y1 + d.y0) / 2)
                .attr("dy", "0.35em")
                .attr("text-anchor", d => d.x0 < width / 2 ? "end" : "start") //checks for right-most labels
                .text(d => d.name)
                .style("font", "14px sans-serif")
              .append("tspan")
                .attr("fill-opacity", 0.7)
                .text(d => ` ${d.value.toLocaleString()}`)
                .style("font", "14px sans-serif")
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

  console.log(links[0].names[0])
  console.log(nodes)
  return {nodes, links};
};

</script>

<style scoped>

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
}



</style>