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
  
    const width = 600
    const height = 800
    const cropTop = 390  // needs to be dropped from exported png
  
    const svg = d3.select(mapContainer.value)
      .append('svg')
      .attr('width', width)
      .attr('height', height-cropTop)
      .attr('viewBox', `0 0 ${width} ${height-2*cropTop}`)
  
    try {
        // load sui suv png
        let scale_size = 1.239
        // doing this because I cant pull the original data right now, and update the exported image dimensions

        svg.append('g')
          .attr('transform', `translate(0, -${cropTop})`)
          .append('image')
            .attr('xlink:href', import.meta.env.BASE_URL + '/assets/01_stress_map.png')
            .attr('x', -71)
            .attr('y', -96.1)
            .attr('width', width*scale_size)
            .attr('height', height*scale_size)

        // load boundary layers
        const topoData = await d3.json(import.meta.env.BASE_URL + '/assets/Regions.topojson')
        const geoData = topojson.feature(topoData, topoData.objects[Object.keys(topoData.objects)[0]])
    
        const projection = d3.geoIdentity().reflectY(true).fitSize([width, height], geoData)
        const path = d3.geoPath().projection(projection)
    
        svg.append('g')
            .attr('transform', `translate(0, -${cropTop})`) 
            .selectAll('path')
            .data(geoData.features)
            .join('path')
            .attr('d', path)
            .attr('fill', 'none')
            .attr('stroke', 'white')
            .attr('stroke-width', "3px")

        // black and white outline...looks questionable. what color works??
        svg.append('g')
            .attr('transform', `translate(0, -${cropTop})`) 
            .selectAll('path')
            .data(geoData.features)
            .join('path')
            .attr('d', path)
            .attr('fill', 'none')
            .attr('stroke', 'grey')
            .attr('stroke-width', "1.5px")

            console.log('Raster Extent:', { width, height });
console.log('Vector Extent:', d3.extent(geoData.features, d => d.geometry.coordinates));

    } catch (error) {
      console.error('Error loading TopoJSON:', error)
    }
  })
  </script>
  
  <style>
  .map-container {
    display: flex;
    width: 100%;
    height: auto;
    justify-content: center;
    align-items: center;
  }
  </style>
  