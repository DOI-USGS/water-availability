<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <p>Exposure to drinking water contamination occurs at higher rates for low-income communities, minority-dominated communities, and those who depend on domestic wells as their drinking water source.</p>
            </div>
            <div
            id="toggle-container"
            class="text-container"
            aria-hidden="true"
            >
              <p>Surface water quality differs by source and use. Broad sources of water contamination include   
                    <span class="highlight" id="Biotic"> biotic threats </span>,
                    <span class="highlight" id="Nutrients"> nutrients </span>,
                    <span class="highlight" id="Organics"> organics  </span>,
                    <span class="highlight" id="Metals"> metal and physical sources </span>, 
                    <span class="highlight" id="Sediment"> sediment </span>, 
                    <span class="highlight" id="Salinity"> salinity </span>, and
                    <span class="highlight" id="Temperature"> temperature </span>. Some areas of surface water are not threatened and are considered
                    <span class="highlight" id="Unimpaired"> unimpaired </span>. This chart shows threats to the water quality of surface water in the U.S. by source and water use category. The height of each ribbon in the chart represents the total river miles, and the broad categories on the left are broken out into their respective sources on the right. 
                </p>
            </div>
            <section id="dw-viz">
              <div class="text-container">
                <h2>Top Threats to Drinking Water</h2>
                <p>Metal contamination, salinity, and sediments were identified as the main threats to streams and rivers used as a drinking-water source. </p>
              </div>
              <div class="viz-container">
                <div id="DW-container">    
                </div>
              </div>
              <div class="text-container">
                <p><br>Iron, selenium, arsenic, lead, and copper are the top non-mercury metals impairing rivers and streams across the United States. These types of metals occur naturally in surface water from geogenic sources such as rock weathering and soil erosion. Human activities like mining, urban runoff, wastewater, fertilizer and pesticide use, fuel combustion, and nuclear reactions can also add substantial volumes of metals to the environment above background levels. Human-derived metals may also be released in more toxic and mobile forms than natural sources. </p>
                <p><br>Salinity effects on water availability are more spatially limited than nutrients, but salinity can cause considerable local issues for human beneficial uses and ecosystem needs. There has been a growing recognition of the threat that freshwater salinization (increasing salinity) of surface waters poses to water availability (Cañedo-Argüelles, 2020), with 37 percent of the drainage area of the CONUS having experienced salinization, primarily in the populated Northeast through Midwest aggregated hydrologic regions (Kaushal and others, 2018; Cañedo-Argüelles, 2020). Trend assessments at individual sites across the United States show increasing salinity with time at many sites, particularly in urban areas, and at concentrations that indicate potential corrosion to drinking-water infrastructure. </p>
              </div>
            </section>
            <section id="fish-viz">
              <div class="text-container">
                <h2>Top Threats to Fish Consumption</h2>
                <p>Water-quality problems that affect ecosystems may also affect people who rely on ecosystems for food. The top threats to fish consumption for human health include mercury and polychlorinated biphenyls (PCBs).
                </p>
              </div>
              <div class="viz-container">
                <div id="fish-container">    
                </div>
              </div>
              <div class="text-container">
                <p>Mercury can limit water availability for aquatic species and humans through consumption of aquatic species. Mercury has geogenic sources (volcanos, hot springs, geologic deposits, and the ocean) and anthropogenic sources (industrial processes, mining, and primarily coal combustion). Dispersion of mercury through the atmosphere has resulted in widespread occurrence of mercury in the environment. The methylated form of mercury, methylmercury, is highly bioavailable and can accumulate in higher trophic levels, such as fish, relative to lower trophic levels at concentrations that make fish consumption unhealthy for humans (Wentz and others, 2014). For example, Arctic Indigenous peoples have a traditional diet rich in marine mammals and fish, which are also a substantial source of mercury exposure. Young children and developing fetuses are particularly vulnerable to mercury exposure through movement across the placenta from mother to fetus. Stream contaminants that threaten fish-consumption use by humans included primarily polychlorinated biphenyls and mercury.</p>
                <p><br>Polychlorinated biphenyls (PCBs) are endocrine-disrupting compounds, associated with cancers and a wide range of human-health risks, are generally stable and persistent in the environment, and can bioaccumulate in aquatic organisms and food webs (Ngoubeyou and others, 2022), leading to concerns for ecological and recreational uses and hazards to human health through fish consumption (fig. 2). Although PCBs were prohibited decades ago, PCB contamination can be common in industrial sites (point sources) and hydrologically connected locations. About 30 percent of the historical worldwide production of PCBs is still present in aquatic ecosystems, sediments, and aquatic food webs (Ngoubeyou and others, 2022). </p>
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
const margin = mobileView 
  ? { top: 60, right: 40, bottom: 20, left: 10 } 
  : { top: 80, right: 50, bottom: 40, left: 150 };
const width = containerWidth - margin.left - margin.right;
const height = containerHeight - margin.top - margin.bottom;
const nodePadding = mobileView ? 24 : 11; // Increase node spacing for mobile
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
      .style('width', '100%')
      .style('height', 'auto');

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
    const categoryGroups = [... new Set(dataset.map(d => d.Category))];
    const parameterGroups = d3.union(d3.map(dataset, d => d.Parameter));
    
    // initialize sankey
    const sankey = d3sankey.sankey()
      .nodeWidth(4)
      .nodePadding(nodePadding) // Increase padding on mobile
      .extent(mobileView 
        ? [[75, 0], [width -50, height - 0]]
        : [[150, 5], [width - 300, height - 0]]); //


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
          const textEnter = enter
            .append("text")
            .attr("x", d => d.x0 < width / 2 ? d.x0 - 10 : d.x1 + 10)  // Push left-side labels inside SVG bounds
            .attr("y", d => (d.y1 + d.y0) / 2)
            .attr("dy", "0.35em")
            .attr("text-anchor", d => d.x0 < width / 2 ? "end" : "start")  // Left-side labels aligned to the end
            .style("font", mobileView ? "14px sans-serif" : "14px sans-serif");

          // Add label text (name and value)
          textEnter
            .append("tspan")
            .text(d => d.name);

          if (mobileView) {
            textEnter
              .append("tspan")
              .attr("x", d => d.x0 < width / 2 ? d.x0 - 10 : d.x1 + 10)  // Adjust x position for second line
              .attr("dy", "1em")  // Move second line down
              .attr("fill-opacity", 0.7)
              .text(d => `${d.value.toLocaleString()}`);
          } else {
            textEnter
              .append("tspan")
              .attr("fill-opacity", 0.7)
              .text(d => ` ${d.value.toLocaleString()}`);
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

  console.log(links[0].names[0])
  console.log(nodes)
  return {nodes, links};
};

window.addEventListener('resize', () => {
  containerWidth = window.innerWidth * 0.8;
  containerHeight = mobileView ? window.innerHeight * 0.9 : 600;
  width = containerWidth - margin.left - margin.right;
  height = containerHeight - margin.top - margin.bottom;
  // Update the chart
  initSankey({ containerWidth, containerHeight, margin, width, height, containerId: 'DW-container' });
  createSankey({ dataset: datasetDW.value, containerId: 'DW-container' });
});



</script>

<style scoped>
.viz-container {
  width: 100%;
  overflow: hidden;
  display: flex;
  justify-content: center; /* Center align the chart */
}

#DW-container, #fish-container, #rec-container {
  width: 100%;
  height: 100%;
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
}



</style>