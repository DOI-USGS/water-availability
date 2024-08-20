<template>
    <section class="main-container">
        <KeyMessages></KeyMessages>
        
            <div class="text-container">
                <p>Sources of excess nutrients in our water include   
                    <span :class="['highlight', 'Agriculture']"> agriculture </span>,
                    <span :class="['highlight', 'Atmosphericdeposition']"> air pollution </span>,
                    <span :class="['highlight', 'Wastewater']"> wastewater  </span>,
                    <span :class="['highlight', 'Otherhumansources']"> other human sources </span>, and
                    <span :class="['highlight', 'Naturalsources']"> natural sources </span>.
                </p>
            </div>
            <div class="viz-container">
        <div id="barplot-container" />    
         </div>
         <div class="viz-container">
            <p>Nutrients have a range of natural and anthropogenic sources. Natural sources of nutrients in surface water include fixation of atmospheric nitrogen by soil bacteria that is transported to streams, geogenic sources, fixation by aquatic bacteria and algae, and lightning strikes. Anthropogenic sources of nutrients in surface water generally include nonpoint fertilizer and manure application, atmospheric deposition (which generally has anthropogenic origins), nitrogen fixation by crops, and point sources such as wastewater treatment plant discharge. Legacy nitrogen stored in groundwater can also be important sources to streams as well. Across the CONUS, primary sources vary spatially, and include fertilizer and manure, atmospheric deposition, wastewater treatment plants, urban land, and a range of natural sources including stream channel and geologic sources.</p>
        
         </div>
         
         <PageCarousel></PageCarousel>
    </section>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import * as d3 from 'd3';
import PageCarousel from '../components/PageCarousel.vue';
import KeyMessages from '../components/KeyMessages.vue';

// Global variables 
const publicPath = import.meta.env.BASE_URL;
const dataSet1 = ref([]); 
const dataSet2 = ref([]); 
const selectedDataSet = ref('dataSet1');
const data = ref([]);
let svg;
//const height = 600;
//const width = 800;
//const margin = { top: 40, right: 20, bottom: 40, left: 40 };

// Colors for bar chart (need to be updated along with CSS below!)
const categoryColors = {
        'Agriculture': '#939185',
        'Atmospheric deposition': '#C8ACD6',
        'Other Human Sources': '#2E236C',
        'Natural sources': '#EECEB9',
        'Wastewater': '#478CCF'
      }; 

// Set default summaryType
const summaryType = 'Count'

onMounted(async () => {
    try {
        await loadDatasets();
        data.value = selectedDataSet.value === 'dataSet1' ? dataSet1.value : dataSet2.value;
        if (data.value.length > 0) {
            createBarChart(summaryType);
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

function createBarChart(currentSummaryType) {

    // Get dynamic dimensions to draw chart
    const containerWidth = 1000;//document.getElementById('barplot-container').offsetWidth;
    const containerHeight = window.innerWidth <= 700 ? window.innerHeight * 0.5 : 1600;
    const margin = window.innerWidth <= 700 ? { top: 40, right: 10, bottom: 20, left: 10 } : { top: 40, right: 20, bottom: 40, left: 100 };
    const width = containerWidth - margin.left - margin.right;
    const height = containerHeight - margin.top - margin.bottom;

    // draw svg canvas for barplot
    svg = d3.select('#barplot-container')
        .append('svg')
        .attr('class', 'barplotSVG')
        .attr('viewBox', `0 0 ${containerWidth} ${containerHeight}`)
        //.attr('preserveAspectRatio', 'xMidYMid meet')
        .style('width', '100%')
        .style('height', '100%');

    // add group for bar chart bounds, translating by chart margins
    const chartBounds = svg.append('g')
        .attr('id', 'wrapper')
        .style("transform", `translate(${
          margin.left
        }px, ${
          margin.top
        }px)`)

    
    // get unique categories and regions
    const categoryGroups = d3.union(d3.map(data.value, d => d.category));
    const regionGroups = d3.union(d3.map(data.value, d => d.region_nam));

    //console.log(categoryGroups);
    //console.log(regionGroups);
    //console.log(data.value[1, 2])
    

    // stack data for rectangles
    const expressed = currentSummaryType === 'Count' ? 'total_load' : 'percent_load';
    const stackedData = d3.stack()
        .keys(categoryGroups)
        .value(([, D], key) => D.get(key)[expressed]) // get value for each series key and stack
        (d3.index(data.value, d => d.region_nam, d => d.category));

    // Set up x scale
    const xScale = d3.scaleLinear()
        .domain([0, d3.max(stackedData, d => d3.max(d, d => d[1]))])
        .range([0, width]);

    // add x axis
    chartBounds.append('g')
        .call(d3.axisTop(xScale)
            .ticks(3)
            .tickFormat(d => currentSummaryType === 'Count' ? d + 'kg/yr' : d + '%'))
        .attr('font-size', '5rem');

    // Set up y scale
    const yScale = d3.scaleBand()
        .domain(regionGroups)
        .range([height, 0]);

    // add y axis
    chartBounds.append('g')
        // breaking build? .attr("transform", `translate(0,${width})`)
        .call(d3.axisLeft(yScale))
        .attr('font-size', '5rem');

    // set up color scale
    const color = d3.scaleOrdinal()
        .domain(categoryGroups)
        //.range(["#FF9100", "#1b695e", "#7a5195", "#2a468f", "#ef5675", "#ff764a", "#ffa600"]);
        //.range(categoryGroups.map(category => categoryColors[category]));
        .range(Object.entries(categoryColors).map(([key, value]) => value));
    //console.log(categoryColors.Agriculture);
    
    // Add group to chart bounds to hold all chart rectangle groups
    const rectGroup = chartBounds.append('g')
        .attr('id', 'rectangle_group')

    // Add subgroup for each category of data
    const categoryRectGroups = rectGroup.selectAll('g')
        .data(stackedData, d => d.key)
        .enter()
        .append('g')
        .attr("id", d => d.key.replace(" ", "_"))
    
    //console.log(stackedData[0])

    // Add rectangles for each region to each category group
    categoryRectGroups.selectAll('rect')
        .data(D => D.map(d => (d.key = D.key, d)))
        .enter().append('rect')
            .attr("class", d => d.key.replace(" ", "_") + ' ' + d.data[0].replace(" ", "_"))
            .attr('x', d => xScale(d[0]))
            .attr('y', d => yScale(d.data[0]))
            .attr('height', yScale.bandwidth())
            .attr('width', d => xScale(d[1]) - xScale(d[0]))
            .style("fill", d => color(d.key));  
}

</script>

<style scoped lang="scss">

.highlight {
  color: white;
  padding: 0.25px 5px;
  border-radius: 10px;
  white-space: nowrap;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.1s;

  &.Agriculture {
    background-color: #939185;
  }

  &.Atmosphericdeposition {
    background-color: #C8ACD6;
  }

  &.Otherhumansources {
    background-color: #2E236C;
  }

  &.Wastewater {
    background-color: #478CCF;
  }

  &.Naturalsources {
    background-color: #EECEB9;
  }
}


</style>