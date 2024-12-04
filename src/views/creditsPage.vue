<template>
  <section>    
    <div class="authors-container">
        <div id="text-container">
            <h1>Website Credits</h1>
        </div>
    </div>
    <div class="authors-container">
      <p>
          This website was developed by the <a href='https://labs.waterdata.usgs.gov/visualizations/' target='_blank'>USGS Vizlab</a>
          <span id="primary-author-statment">
            and led by 
            <span
              v-for="(author, index) in authorLeads" 
              :id="`initial-${author.initials}`"
              :key="`${author.initials}-attribution`"
              :class="'author first'"
            >
              <a
                :href="author.profile_link"
                target="_blank"
                v-text="author.fullName"
              />
              <span v-if="index != Object.keys(authorLeads).length - 1 && Object.keys(authorLeads).length > 2">, </span>
              <span v-if="index == Object.keys(authorLeads).length - 2"> and </span>
            </span>.
          </span>
        </p>
    </div>
    <div class="authors-container">
      <h2>Meet the Vizlab Team</h2>
        <div class="chart-container">
            <div ref="chart" class="chart"></div>
        </div>
        <p>
            The USGS Vizlab is a data visualization team within the USGS <a href='https://www.usgs.gov/mission-areas/water-resources' target='_blank'>Water Resources Mission Area</a>. View the Vizlab <a href='https://labs.waterdata.usgs.gov/visualizations/' target='_blank'>portfolio</a>.
          <span id="primary-author-statment">
            Vizlab team members that contributed to this website include
            <span
              v-for="(author, index) in authorsVizlab" 
              :id="`initial-${author.initials}`"
              :key="`${author.initials}-attribution`"
              :class="'author first'"
            >
              <a
                :href="author.profile_link"
                target="_blank"
                v-text="author.fullName"
              />
              <span v-if="index != Object.keys(authorsVizlab).length - 1 && Object.keys(authorsVizlab).length > 2">, </span>
              <span v-if="index == Object.keys(authorsVizlab).length - 2"> and </span>
            </span>.
          </span>
        </p>
    </div>
    <div class="authors-container">
        <h2>Meet the National IWAAs Authors</h2>
        <div class="chart-container">
            <div ref="chartSME" class="chart"></div>
        </div>
        <p>
            The chapter leads for the National Integrated Water Availability Assessment Report include
          <span id="primary-author-statment">
            <span
              v-for="(author, index) in authorSMEs" 
              :id="`initial-${author.initials}`"
              :key="`${author.initials}-attribution`"
              :class="'author first'"
            >
              <a
                :href="author.profile_link"
                target="_blank"
                v-text="author.fullName"
              />
              <span v-if="index != Object.keys(authorSMEs).length - 1 && Object.keys(authorSMEs).length > 2">, </span>
              <span v-if="index == Object.keys(authorSMEs).length - 2"> and </span>
            </span>.
          </span>
        </p>
      </div>
    <div class="report-link-container">
          <a href="index.html" rel="noopener noreferrer" class="report-link">
            <h3> Return Home</h3>
          </a>       
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import * as d3 from 'd3';
import { isMobile } from 'mobile-device-detect';
import authorList from '@/assets/text/authors.js';

const authorLeads = authorList.leads;

const authorsVizlabUnsort = authorLeads.concat(authorList.devs);

const authorsVizlab = authorsVizlabUnsort.sort((a, b) => a.fullOrder - b.fullOrder);

const authorSMEs = authorList.scientists;

let container = ref();
let data = ref();

//const props = {
//    data: authorsVizlab}
const props = {
  data: authorsVizlab
};
const propsSME = {
    data: authorSMEs
}
console.log(props.data[0].headshot)

// images

const chart = ref(null);
const chartSME = ref(null);

onMounted(() => {
  createChart({container: chart.value, data: [...props.data], team: 'Vizlab'});
  createChart({container: chartSME.value, data: [...propsSME.data], team: 'scientists'});

  window.addEventListener('resize', createChart);
});

function createChart({ container, data, team }) {


    // Clear any existing SVG elements
    d3.select(container).selectAll('*').remove();

    const margin = { top: 20, right: 10, bottom: 20, left: 10 };
    const width = container.clientWidth - margin.left - margin.right;
    const radius = isMobile ? 50 : 80; // Fixed circle size
    const padding = isMobile ? 2 : 10; // Padding between circles

    // Calculate the number of columns and rows based on screen width
    const columns = Math.floor(width / (2 * radius));
    const rows = Math.ceil(data.length / columns);
    console.log(columns)

    // Calculate the required height dynamically
    const height = rows * (2 * radius + padding) + margin.top + margin.bottom;

    const svg = d3
        .select(team === 'Vizlab' ? chart.value : chartSME.value)
        .append('svg')
        .attr('width', width + margin.left + margin.right)
        .attr('height', height)
        .attr('viewBox', `0 0 ${width + margin.left + margin.right} ${height}`)
        .append('g')
        .attr('transform', `translate(${margin.left},${margin.top})`);

    // Build array to use to position elements based on indices
    let xCenter = [];
    for (let i = 0; i <= data.length - 1; i++) {
        xCenter.push(i * 100)
    }
    d3.forceSimulation(data)
        .force("x", d3.forceX((d, i) => {
            return xCenter[i];
        }).strength(1))
        .force("center", d3.forceCenter(width / 2, (height - margin.top - margin.bottom) / 2).strength(1))
        .force("charge", d3.forceManyBody().strength(30))

        .force("collision", d3.forceCollide().radius(radius + padding))
        .on("tick", ticked);

    const node = svg
        .selectAll("g")
        .data(data)
        .enter()
        .append("g")
        .attr('class', 'node')
        .on('click', function (event, d) {
        console.log('Clicked:', d.profile_link); // Log to ensure click event is triggered
        });

    node
        .append('clipPath')
        .attr('id', (d, i) => `clip-${i}`)
        .append('circle')
        .attr('r', radius);

    node
        .append('circle')
        .attr('class', 'face')
        .attr('r', radius)
        .attr('fill', 'black')
        .attr('stroke-width', '5px')
        .attr('clip-path', (d, i) => `url(#clip-${i})`);

    node
        .append('image')
        .attr('xlink:href', d => d.headshot)
        .attr('width', radius * 2.1)
        .attr('height', radius * 2.1)
        .attr('x', -1.05 * radius)
        .attr('y', -radius)
        .attr('clip-path', (d, i) => `url(#clip-${i})`);

    node
        .append('circle')
        .attr('class', 'overlay')
        .attr('r', radius)
        .attr('fill', 'rgba(0, 0, 0, 0.5)')
        .style('opacity', 0);

    node
        .append('text')
        .attr('x', 0)
        .attr('y', 0)
        .attr('text-anchor', 'middle')
        .attr('dy', '.35em')
        .attr('class', 'name-text')
        .attr('font-weight', 'bold')
        .attr('fill', 'white')
        .attr('pointer-events', 'none')
        .style('opacity', 0)
        .text(d => d.fullName);

    // append link
    node    
        .append("a")
        .attr("href", d => d.profile_link)
        .attr("target", "_blank")
        .append("svg:rect")
            .attr("y", -radius)
            .attr("x", -radius)
            .attr("height", radius * 2)
            .attr("width", radius * 2)
            .style("fill", "transparent")
            .attr('clip-path', (d, i) => `url(#clip-${i})`);

    node
        .on('mouseover', function () {
        d3.select(this).select('.overlay')
            .transition()
            .duration(200)
            .style('opacity', 1);
        d3.select(this).select('.name-text')
            .transition()
            .duration(200)
            .style('opacity', 1);
        })
        .on('mouseout', function () {
        d3.select(this).select('.overlay')
            .transition()
            .duration(200)
            .style('opacity', 0);
        d3.select(this).select('.name-text')
            .transition()
            .duration(200)
            .style('opacity', 0);
        });

    function ticked() {
        node.attr("transform", d => {
        d.x = Math.max(radius, Math.min(width - radius, d.x));
        if (rows == 1) {
            d.y = (height - margin.top - margin.bottom) / 2;
        } else {
            d.y = Math.max(radius, Math.min(height - margin.top - margin.bottom - radius, d.y));
        }
        return `translate(${d.x},${d.y})`;
        });
    }
  }


</script>

<style scoped>


/* text box within the wavy container that houses key messages */

.authors-container {
  width: 60vw;
  margin: 0 auto;
  padding: 10px 0 10px 0;
}
@media only screen and (max-width: 768px) {
  .authors-container{
    width: 90vw;
  }
}


#authors {
    font-style: italic;
    font-weight: 300;
  }



.key-message-item-text {
  color: var(--blue-dark);
  width: 100%;
  text-align: left;
}

.chart-container {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
}

.chart {
  width: 100%;
  height: 100%;
}

</style>