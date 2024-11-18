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
      .attr('viewBox', `0 -30 700 100`)
      .attr('preserveAspectRatio', 'xMidYMid meet') // center and scale dynamically
      .attr('class', 'bar-chart-svg')
    
    let activeRegion = null; // Track the currently selected region

    resizeSvg();
    window.addEventListener('resize', resizeSvg);
  
    try {
        // load sui suv png
        let scale_size = 1.239
        // doing this because I cant pull the original data right now, and update the exported image dimensions

        svg.append('g')
          .append('image')
            .attr('xlink:href', import.meta.env.BASE_URL + '/assets/01_stress_map.png')
            .attr('x', -71)
            .attr('y', -96.1)
            .attr('width', width*scale_size)
            .attr('height', height*scale_size)

        // load boundary layers
        const topoData = await d3.json(import.meta.env.BASE_URL + '/assets/Regions.topojson')
        const geoData = topojson.feature(topoData, topoData.objects[Object.keys(topoData.objects)[0]])
        const csvData = await d3.csv(import.meta.env.BASE_URL + '/wa_stress_stats.csv');

        const projection = d3.geoIdentity().reflectY(true).fitSize([width, height], geoData)
        const path = d3.geoPath().projection(projection)
    
        svg.append('g')
            .selectAll('path')
            .data(geoData.features)
            .join('path')
            .attr('d', path)
            .attr('class', d => `region-${d.properties.Region_nam_nospace}`)
            .attr('fill', 'transparent')
            .attr('stroke', 'white')
            .attr('stroke-width', "2px")
            .on('mouseover', function (event, d) {
                if (activeRegion !== d.properties.Region_nam_nospace) {
                    d3.select(this)
                    .attr('stroke', 'black')
                    .attr('stroke-width', '2px');
                }
                const regionClass = `region ${d.properties.Region_nam_nospace}`;
                const regionClassFilter = d.properties.Region_nam;
                const filteredData = csvData.filter(row => row.Region_nam === regionClassFilter);

                updateBarChart(filteredData);
            })
            .on('mouseout', function (event, d) {
        if (activeRegion !== d.properties.Region_nam_nospace) {
          d3.select(this)
          .attr('stroke', 'white')
          .attr('stroke-width', "2px")
        }
      })
      .on('click', function (event, d) {
        // Reset previous active region
        paths.attr('stroke', 'white')
        .attr('stroke-width', "2px")

        // Highlight selected region
        d3.select(this)
          .attr('stroke', 'red')
          .attr('stroke-width', '3px');

        activeRegion = d.properties.Region_nam_nospace;

        // Update bar chart
        const regionClassFilter = d.properties.Region_nam;
        const filteredData = csvData.filter(row => row.Region_nam === regionClassFilter);
        updateBarChart(filteredData);
      });

        // black and white outline...looks OK
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

            const formatPercentage = d3.format('.0f');

            g.select('.chart-title').remove(); // Clear old title
            g.append('text')
                .attr('class', 'chart-title')
                .attr('x', 0)
                .attr('y', -10)
                .attr('fill', 'black')
                //.attr("font-weight", "500")
                .attr('font-size', '2.2rem')
                .attr('text-anchor', 'start')
                .text(d => `Water stress in the ${data[0]?.Region_nam} region`);

            g.selectAll('.chart-labels').remove(); // Clear old labels
            g.selectAll('.chart-labels')
                .data(data)
                .join('text')
                .attr('class', 'chart-labels')
                .attr('x', (d, i) => xScale(d3.sum(values.slice(0, i)) + d.percentage_stress / 2))
                .attr('y', 50)
                .attr('fill', 'black')
                .attr('text-anchor', 'middle')
                .text(d => `${formatPercentage(d.percentage_stress)}%`);
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
  