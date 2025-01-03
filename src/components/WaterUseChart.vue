<template>
    <div id="barplot-container"></div>
  </template>
  
  <script setup>
  import { watch, onMounted, nextTick } from 'vue';
  import * as d3 from 'd3';
  
  const props = defineProps({
    isFaceted: Boolean, // toggle between stacked and faceted views
    dataSet: Array, // chart data
    mobileView: Boolean, // responsive check
  });
  
  // global variables for svg and data
  let svg, chartBounds, rectGroup;
  let categoryGroups, yearGroups, stackedData;
  let yearScale, useScale, categoryRectGroups;
  
  // constants for sizing
  const containerWidth = 700;
  const containerHeight = 700;
  const margin = props.mobileView
    ? { top: 60, right: 10, bottom: 50, left: 40 }
    : { top: 80, right: 10, bottom: 60, left: 0 };
  
  const width = containerWidth - margin.left - margin.right;
  const height = containerHeight - margin.top - margin.bottom;
  
  // colors for categories
  const categoryColors = {
    'Public Supply': 'var(--wu-ps)',
    'Irrigation': 'var(--wu-agriculture)',
    'Thermoelectric (fresh)': 'var(--wu-te-fresh)',
    'Thermoelectric (saline)': 'var(--wu-te-saline)',
  };
  
  // initialize chart
  function initChart() {
    svg = d3.select('#barplot-container')
      .append('svg')
      .attr('viewBox', `-40 0 ${containerWidth + 20} ${containerHeight}`)
      .style('width', containerWidth)
      .style('height', containerHeight);
  
    chartBounds = svg.append('g')
      .attr('transform', `translate(${margin.left}, ${margin.top})`);
  
    rectGroup = chartBounds.append('g').attr('id', 'rectangle_group');
  }
  
  // create stacked bar chart
  function createStackedChart(data) {
    categoryGroups = [...new Set(data.map(d => d.Use))];
    yearGroups = d3.union(data.map(d => d.water_year));
  
    stackedData = d3.stack()
      .keys(categoryGroups)
      .value(([, D], key) => D.get(key)['mgd'])
      (d3.index(data, d => d.water_year, d => d.Use));
  
    yearScale = d3.scaleBand()
      .domain(yearGroups)
      .range([0, width])
      .padding(0.02);
  
    useScale = d3.scaleLinear()
      .domain([0, d3.max(stackedData, d => d3.max(d, d => d[1]))])
      .range([height, 0]);
  
    const colorScale = d3.scaleOrdinal()
      .domain(categoryGroups)
      .range(categoryGroups.map(item => categoryColors[item]));
  
    categoryRectGroups = rectGroup.selectAll('g')
      .data(stackedData)
      .join(enter => enter.append('g')
        .attr('id', d => d.key.replace(/[ ()]/g, '_')));
  
    categoryRectGroups.selectAll('rect')
      .data(D => D.map(d => (d.key = D.key, d)))
      .join(enter => enter.append('rect')
        .attr('x', d => yearScale(d.data[0]))
        .attr('y', d => useScale(d[1]))
        .attr('height', d => useScale(d[0]) - useScale(d[1]))
        .attr('width', yearScale.bandwidth() - 5)
        .style('fill', d => colorScale(d.key)));
  }
  
  // transition to faceted view
  function transitionToFaceted() {
    const facetHeight = height / categoryGroups.length;
    const t = d3.transition().duration(500);
  
    categoryGroups.forEach((group, i) => {
      const groupScale = d3.scaleLinear()
        .domain([0, d3.max(props.dataSet.filter(d => d.Use === group), d => +d.mgd)])
        .range([facetHeight, 0]);
  
      d3.select(`g #${group.replace(/[ ()]/g, '_')}`)
        .selectAll('rect')
        .transition(t)
        .attr('y', d => groupScale(+d.mgd))
        .attr('height', d => facetHeight - groupScale(+d.mgd));
    });
  }
  
  // transition back to stacked view
  function transitionToStacked() {
    const t = d3.transition().duration(500);
  
    categoryRectGroups.selectAll('rect')
      .transition(t)
      .attr('y', d => useScale(d[1]))
      .attr('height', d => useScale(d[0]) - useScale(d[1]));
  }
  
  // watch for toggle change
  watch(() => props.isFaceted, (newVal) => {
    nextTick(() => {
      newVal ? transitionToFaceted() : transitionToStacked();
    });
  });
  
  // initialize chart
  onMounted(() => {
    initChart();
    createStackedChart(props.dataSet);
  });
  </script>
  
  <style scoped>
  #barplot-container {
    max-width: 100%;
    width: 100%;
    margin: auto;
  }
  </style>
  