<template>
    <div class="text-container">
        <div ref="barContainer" class="bar-container"></div>
    </div>
    <div ref="mapContainer" class="map-container"></div>
  </template>
  
  <script setup>
  import { onMounted, ref } from 'vue'
  import * as d3 from 'd3'
  import * as topojson from 'topojson-client'
  
  const mapContainer = ref(null)
  const barContainer = ref(null)
  
  onMounted(async () => {
    if (!mapContainer.value) {
      console.error('mapContainer is not defined')
      return
    }
  
    const width = 600 // match to export
    const height = 800 // match to export
    const cropTop = 200  // crop 390px from top
    const cropBottom = 200 // crop 200px from bottom
    const visibleHeight = height - cropTop - cropBottom

    const maxHeight = 700;
  
    const svg = d3.select(mapContainer.value)
      .append('svg')
      .attr('viewBox', `0 ${cropTop} ${width} ${visibleHeight}`)
      .attr('preserveAspectRatio', 'xMidYMid meet') // center and scale dynamically
      .classed('responsive-svg', true)

      const resizeSvg = () => {
        const containerWidth = mapContainer.value.clientWidth;
        const containerHeight = Math.min(mapContainer.value.clientHeight, maxHeight);

        svg.attr('width', containerWidth)
        .attr('height', containerHeight);
    };

    const svgBar = d3.select(barContainer.value)
      .append('svg')
      .attr('viewBox', `0 0 700 100`)
      .attr('preserveAspectRatio', 'xMidYMid meet') // center and scale dynamically
      .attr('class', 'bar-chart-svg')

    resizeSvg();
    window.addEventListener('resize', resizeSvg);
  
    try {
        // load sui suv png
        let scale_size = 1.239
        // doing this because I cant pull the original data right now, and update the exported image dimensions

        svg.append('g')
          //.attr('transform', `translate(0, -${cropTop})`)
          .append('image')
            .attr('xlink:href', import.meta.env.BASE_URL + '/assets/01_stress_map.png')
            .attr('x', -71)
            .attr('y', -96.1)
            .attr('width', width*scale_size)
            .attr('height', height*scale_size)

        // load boundary layers
        const topoData = await d3.json(import.meta.env.BASE_URL + '/assets/Regions.topojson')
        const geoData = topojson.feature(topoData, topoData.objects[Object.keys(topoData.objects)[0]])

        // Load wa_stress_stats.csv
      const csvData = await d3.csv(import.meta.env.BASE_URL + '/wa_stress_stats.csv');
      const csvLookup = Object.fromEntries(csvData.map(d => [d.Region_nam_nospace, d]));

    
        const projection = d3.geoIdentity().reflectY(true).fitSize([width, height], geoData)
        const path = d3.geoPath().projection(projection)
    
        svg.append('g')
            .selectAll('path')
            .data(geoData.features)
            .join('path')
            .attr('d', path)
            .attr('class', d => `region-${d.properties.Region_nam_nospace}`)
            .attr('fill', 'none')
            .attr('stroke', 'white')
            .attr('stroke-width', "2px")
            .on('mouseover', function (event, d) {
                const regionClass = `region ${d.properties.Region_nam_nospace}`;
                const regionClassFilter = d.properties.Region_nam;
                const filteredData = csvData.filter(row => row.Region_nam === regionClassFilter);

                updateBarChart(filteredData);
            });

        // black and white outline...looks questionable. what color works??
        svg.append('g')
            .selectAll('path')
            .data(geoData.features)
            .join('path')
            .attr('d', path)
            .attr('fill', 'none')
            .attr('stroke', 'grey')
            .attr('stroke-width', "0.65px")
        
        // Create stacked bar chart
        svgBar.selectAll('g').remove(); // Clear old chart
        const g = svgBar.append('g')

        const updateBarChart = (data) => {
            if (!data.length) return;

            const categories = data.map(d => d.sui_category_5);
            const values = data.map(d => +d.percentage_stress);
            const colors = d3.scaleOrdinal()
                .domain(categories)
                .range(['#965a6b', '#Cfacab', '#edeadf', '#80909D', '#39424f']); 

            const xScale = d3.scaleLinear()
                .domain([0, d3.sum(values)])
                .range([0, 700]);

            g.selectAll('rect')
                .data(data)
                .join('rect')
                .attr('x', (d, i) => xScale(d3.sum(values.slice(0, i))))
                .attr('y', 0)
                .attr('width', d => xScale(d.percentage_stress))
                .attr('height', 30)
                .attr('fill', d => colors(d.sui_category_5));

            g.selectAll('text')
                .data(data)
                .join('text')
                .attr('x', (d, i) => xScale(d3.sum(values.slice(0, i)) + d.percentage_stress / 2))
                .attr('y', 20)
                .attr('fill', '#fff')
                .attr('text-anchor', 'middle')
                .text(d => `${d.sui_category_5}: ${(d.percentage_stress).toFixed(1)}%`);
        };

        } catch (error) {
        console.error('Error loading TopoJSON:', error)
        }
  })
  </script>
  
  <style>
 .map-container {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%; 
  height: auto;
  max-height: 700px;
}

.responsive-svg {
  width: 100%; 
  height: auto; /* maintains aspect ratio */
  max-height: 100%;
}
.bar-chart-svg {
  width: 100%; 
  height: auto; /* maintains aspect ratio */
  max-height: 100%;
}
  </style>
  