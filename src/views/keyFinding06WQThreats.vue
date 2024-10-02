<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        <div class="content-container">
            <div class="text-container">
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat.</p>
            </div>
            <div class="button-container">
                <button id="image-toggle" class="toggle-button">Click to change view</button>
            </div>
            <div class="viz-container">
                <div id="sankey-container">    
                </div>
            </div>
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
import photoProportion from "@/assets/images/k06_wq_by_use.png";
import photoMiles from "@/assets/images/k06_wq_by_use_noImpaired.png";

// use for mobile logic
const mobileView = isMobile;

// Global variables 
const publicPath = import.meta.env.BASE_URL;
const dataSet = ref([]);
const data = ref([]);
let svg;
const containerWidth = window.innerWidth * 0.8;
const containerHeight = mobileView ? window.innerHeight * 0.7 : 600;
const margin = mobileView ? { top: 60, right: 20, bottom: 20, left: 100 } : { top: 80, right: 20, bottom: 40, left: 100 };
const width = containerWidth - margin.left - margin.right;
const height = containerHeight - margin.top - margin.bottom;
let chartBounds;
let rectGroup;
const scaleMiles = ref(true);
const showDW = ref(true);

// Abbreviations
//  DW = Drinking Water Use
//  Eco = Ecological Use
//  Fish = Fish Consumption Use
//  Rec = Recreational Use
//  Other = Other Use

// Colors for threat categories, Needs to be updated with CSS for text legend
const categoryColors = {
    'Biotic Metals and Physical':  '#C8ACD6',
    'Nutrients':  '#2E236C',
    'Organics':  '#478CCF', 
    'Salinity': '#EECEB9',
    'Sediment': '#939185',
    'Temp': '#F41A90',
    'Unimpaired': '#1687A5',
      }; 

// set up filtered chart data as computed property for text legend
const showUseType = computed(() => {
    return showDW.value ? 'drinking water' : 'fish consumption'
});

// set up filtered chart data as computed property for text legend
const scaleType = computed(() => {
    return scaleMiles.value ? 'total miles' : 'percent of total miles'
});

onMounted(async () => {
    try {
        await loadDatasets();
        data.value = dataSet.value;
        if (data.value.length > 0) {
            initSankey({
              containerWidth: containerWidth,
              containerHeight: containerHeight,
              margin: margin,
              width: width,
              height: height
            });
            createSankey({
              dataset: data.value,
              use: showDW.value,
              scaleMiles: scaleMiles.value
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
    dataSet.value = await loadData('wq_threats.csv');
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

// Function to switch between total river miles and percent of river miles
function toggleScale() {
  scaleMiles.value = !scaleMiles.value
        createSankey({
          dataset: data.value,
          use: showDW.value,
          scaleMiles: scaleMiles.value
    })
};

// Function to switch water use categories
function toggleUse() {
  showDW.value = !showDW.value
    createSankey({
        dataset: data.value,
        use: showDW.value,
        scaleMiles: scaleMiles.value
    })
};

function initSankey({
        containerWidth,
        containerHeight,
        margin
    }) {

    // draw svg canvas for sankey
    svg = d3.select('#sankey-container')
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

    // Add group to chart bounds to hold all chart rectangle groups
    rectGroup = chartBounds.append('g')
      .attr('id', 'rectangle_group')

};

function createSankey({
    dataset,
    use,
    scaleMiles
  }) {

    // get unique categories and parameters
    const categoryGroups = d3.union(d3.map(dataset, d => d.Category));
    const parameterGroups = d3.union(d3.map(dataset, d => d.Parameter));
    
    // initialize sankey
    const sankey = d3sankey.sankey()
        .nodeSort(null)
        .linkSort(null)
        .nodeWidth(3)
        .nodePadding(20)
        .extent([[0, 5], [containerWidth, containerHeight - 5]])

    // Set up color scale 
    const colorScale = d3.scaleOrdinal()
        .domain(categoryGroups)
        .range(Object.values(categoryColors));

    console.log(colorScale)



};


</script>

<style scoped>





</style>