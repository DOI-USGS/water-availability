<template>
    <div ref="mapContainer" class="map-container"></div>
  </template>
  
  <script setup>
  import { onMounted, ref } from 'vue'
  import * as d3 from 'd3'
  import * as topojson from 'topojson-client'
  
  const mapContainer = ref(null)
  
  onMounted(async () => {
    if (!mapContainer.value) {
      console.error('mapContainer is not defined')
      return
    }
  
    const width = 800
    const height = 600
  
    const svg = d3.select(mapContainer.value)
      .append('svg')
      .attr('width', width)
      .attr('height', height)
  
    try {
      const topoData = await d3.json(import.meta.env.BASE_URL + '/assets/Regions.topojson')
      const geoData = topojson.feature(topoData, topoData.objects[Object.keys(topoData.objects)[0]])
  
      const projection = d3.geoIdentity().reflectY(true).fitSize([width, height], geoData)
      const path = d3.geoPath().projection(projection)
  
      svg.append('g')
        .selectAll('path')
        .data(geoData.features)
        .join('path')
        .attr('d', path)
        .attr('fill', 'none')
        .attr('stroke', 'black')
    } catch (error) {
      console.error('Error loading TopoJSON:', error)
    }
  })
  </script>
  
  <style>
  .map-container {
    width: 100%;
    height: auto;
  }
  </style>
  