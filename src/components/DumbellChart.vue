<template>
    <div class="viz-container">
      <!-- Chart container -->
      <div id="dotplot-container"></div>
    </div>
  </template>
  
  <script setup>
  import * as d3 from 'd3';
  import { onMounted, watch, defineProps, defineModel, ref } from 'vue';
  
  // props
 const props = defineProps({
    data: {
      type: Array,
      required: true
    },
    animateTime: {
      type: Number,
      default: 500 // animation time in ms
    }
});

// reactive chart data
const supplyEnabled = defineModel('supplyEnabled', { type: Boolean, default: true });
const demandEnabled = defineModel('demandEnabled', { type: Boolean, default: true });
const dataset = ref([]);

// chart dimensions etc
let svg, chartBounds, xScale, originalXScaleDomain, dotGroup;
const publicPath = import.meta.env.BASE_URL;

// dynamic dimensions
const margin = { top: 20, right: 100, bottom: 30, left: 250 }; // increase left margin for y-axis labels
let width, height;
  
// initialize chart
const initChart = (containerWidth) => {

  // calculate responsive dimensions
  width = containerWidth - margin.left - margin.right;
  height = Math.min(window.innerHeight * 0.7, 700) - margin.top - margin.bottom;

  // remove any existing SVG before redrawing
  d3.select('#dotplot-container').select('svg').remove();

  svg = d3.select('#dotplot-container')
    .append('svg')
    .attr('viewBox', `0 0 ${containerWidth} ${height + margin.top + margin.bottom}`)
    .attr('preserveAspectRatio', 'xMidYMid meet')
    .style('width', '100%')
    //.style('max-height', `${height}px`)
    .style('height', 'auto');

  // add chart area group
  chartBounds = svg.append('g')
    .attr('transform', `translate(${margin.left}, ${margin.top})`); 

    dotGroup = chartBounds.append('g');
};

// draw chart
const drawChart = () => {
  //const dataset = props.data;

  if (!dataset || dataset.length === 0) {
    console.warn('No data available to draw the chart.');
    return; // exit if no data
  }

  const yAccessor = d => d['Region_nam'];

  // scales
  const xScaleDomain = d3.extent([
    ...dataset.value.map(d => +d.supply_mean),
    ...dataset.value.map(d => +d.demand_mean)
  ]);

  xScale = d3.scaleLinear()
    .domain(xScaleDomain)
    .range([0, width])
    .nice();

  originalXScaleDomain = xScale.domain();

  const yScale = d3.scaleBand()
    .domain(dataset.value.map(yAccessor))
    .range([0, height])
    .padding(0.1);

  dotGroup.selectAll("*").remove();

  // axes
  dotGroup.append('g')
    .attr('class', 'x-axis-bottom')
    .attr('transform', `translate(0, ${height})`)
    .call(d3.axisBottom(xScale).ticks(5));

  dotGroup.append('g')
    .attr('class', 'x-axis-top')
    .call(d3.axisTop(xScale).ticks(5));

  dotGroup.append('g')
    .attr('class', 'y-axis')
    .call(d3.axisLeft(yScale));

    // region axis
    dotGroup.select('.y-axis')
      .selectAll(".tick")
      .select("text")
      .attr('class', 'chart-text')
      .attr("x", -50);

    d3.xml(`${publicPath}assets/USregions.svg`).then(function(xml) {
      const svgNode = xml.documentElement;

      dotGroup.select('.y-axis')
        .selectAll(".tick")
        .each(function(d) {
          const regionClass = d.replace(/\s+/g, '_');
          const svgClone = svgNode.cloneNode(true);

          const insertedSvg = d3.select(this)
            .insert(() => svgClone, "text")
            .attr("x", -46)
            .attr("y", -25)
            .attr("width", 50)
            .attr("height", 50)
            .attr("fill", "var(--inactive-grey)");

          insertedSvg.selectAll(`g.${regionClass} path`)
            .attr("stroke", "black")
            .attr("stroke-width", 3)
            .attr("fill", "black");
        });
    });

  //add connecting lines
  chartBounds.selectAll('.line')
    .data(dataset.value)
    .enter().append('line')
    .attr('class', 'line')
    .attr('x1', d => xScale(d.supply_mean))
    .attr('x2', d => xScale(d.demand_mean))
    .attr('y1', d => yScale(d.Region_nam) + yScale.bandwidth() / 2)
    .attr('y2', d => yScale(d.Region_nam) + yScale.bandwidth() / 2)
    .style('opacity', 0.4)
    .attr('stroke', '#ccc')
    .attr('stroke-width', 3);

  // circles for supply
  chartBounds.selectAll('.circle-supply')
    .data(dataset.value)
    .enter().append('circle')
    .attr('class', 'circle-supply')
    .attr('cx', d => xScale(d.supply_mean))
    .attr('cy', d => yScale(d.Region_nam) + yScale.bandwidth() / 2)
    .attr('r', 6)
    .attr('fill', 'var(--ws-demand)');

  // circles for demand
  chartBounds.selectAll('.circle-demand')
    .data(dataset.value)
    .enter().append('circle')
    .attr('class', 'circle-demand')
    .attr('cx', d => xScale(d.demand_mean))
    .attr('cy', d => yScale(d.Region_nam) + yScale.bandwidth() / 2)
    .attr('r', 5)
    .attr('stroke', 'var(--ws-demand)')
    .attr('stroke-width', '2px')
    .attr('fill', 'white');
  
};
// toggle points on and off
const togglePoints = () => {
  //const dataset = props.data;

  if (!dataset || dataset.length === 0) {
    console.warn('No data available to toggle points.');
    return;
  }

  // filter visible points based on toggles
  const visibleSupply = supplyEnabled.value
    ? dataset.value.map(d => +d.supply_mean)
    : [];
  const visibleDemand = demandEnabled.value
    ? dataset.value.map(d => +d.demand_mean)
    : [];

  const visiblePoints = [...visibleSupply, ...visibleDemand];
  const newDomain = visiblePoints.length > 0
    ? d3.extent(visiblePoints)
    : originalXScaleDomain;

  // update x-axis domain
  xScale.domain(newDomain).nice();

  // update x-axis
  d3.selectAll('.x-axis-bottom')
    .transition()
    .duration(props.animateTime)
    .call(d3.axisBottom(xScale).ticks(5));

  d3.selectAll('.x-axis-top')
    .transition()
    .duration(props.animateTime)
    .call(d3.axisTop(xScale).ticks(5));

  // update circles for supply
  chartBounds.selectAll('.circle-supply')
    .transition()
    .duration(props.animateTime)
    .attr('cx', d => xScale(d.supply_mean))
    .style('opacity', supplyEnabled.value ? 1 : 0);

  // update circles for demand
  chartBounds.selectAll('.circle-demand')
    .transition()
    .duration(props.animateTime)
    .attr('cx', d => xScale(d.demand_mean))
    .style('opacity', demandEnabled.value ? 1 : 0);

  // update connecting lines
  chartBounds.selectAll('.line')
    .transition()
    .duration(props.animateTime)
    .style('opacity', supplyEnabled.value && demandEnabled.value ? 0.4 : 0);
};

// resize chart dynamically
const resizeChart = () => {
  const containerWidth = document.getElementById('dotplot-container').clientWidth;
  initChart(containerWidth);
  drawChart();
};

// initialize chart when mounted
onMounted(() => {
    dataset.value = props.data; // initialize data
    resizeChart();
    togglePoints();
    // observe resizing
  const resizeObserver = new ResizeObserver(() => {
    resizeChart();
  });

  resizeObserver.observe(document.getElementById('dotplot-container'));
});

// watch toggles for updates
watch([supplyEnabled, demandEnabled], () => {
  togglePoints();
});
// watch data updates
watch(() => props.data, (newData) => {
  dataset.value = newData; // update reactive data
  resizeChart();
  togglePoints();
});

</script>

<style scoped>
.viz-container {
  width: 100%;
  min-width: 700px;
  height: auto;
}
#dotplot-container {
    width: 100%;
    margin: auto;
    min-width: 700px;
}
</style>