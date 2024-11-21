<template>
    <div class="text-container">
      <div ref="barContainer" class="bar-container"></div>
    </div>
    <div ref="mapContainer" class="map-container"></div>
  </template>
  
  <script setup>
  import { onMounted, ref, watch } from 'vue'
  import * as d3 from 'd3'
  import * as topojson from 'topojson-client'
  
  const mapContainer = ref(null)
  const barContainer = ref(null)
  let mapLayers;

  const props = defineProps({
  layerVisibility: {
    type: Object,
    required: true
  }
})

const updateLayers = () => {
  if (!mapLayers) return // ensure mapLayers is initialized

  const visibleLayers = Object.entries(props.layerVisibility).map(([key, value]) => ({
    key,
    path: layerPaths[key]?.path,
    visible: value.visible
  }))

  console.log('Visible layers:', visibleLayers) // debug log

  mapLayers.selectAll('image')
    .data(visibleLayers, d => d.key) // use key as the identifier
    .join(
      enter => enter.append('image')
        .attr('xlink:href', d => import.meta.env.BASE_URL + d.path)
        .attr('x', -80)
        .attr('y', -55)
        .attr('width', 800 * 1.2)
        .attr('height', 550 * 1.2)
        .style('opacity', d => (d.visible ? 1 : 0))
        .style('display', d => (d.visible ? 'block' : 'none')), // ensure full hiding
      update => update
        .style('opacity', d => (d.visible ? 1 : 0))
        .style('display', d => (d.visible ? 'block' : 'none')), // ensure full hiding
      exit => exit.remove()
    )
}


watch(
  () => props.layerVisibility,
  () => {
    updateLayers(); // Trigger layer updates
  },
  { deep: true }
);



const layerPaths = {
  very_low_or_none: {
    path: '/assets/01_stress_map_very_low_none.png',
    color: '#39424f',
    order: 1
  },
  low: {
    path: '/assets/01_stress_map_low.png',
    color: '#80909D',
    order: 2
  },
  moderate: {
    path: '/assets/01_stress_map_moderate.png',
    color: '#edeadf',
    order: 3
  },
  high: {
    path: '/assets/01_stress_map_high.png',
    color: '#Cfacab',
    order: 4
  },
  severe: {
    path: '/assets/01_stress_map_severe.png',
    color: '#965a6b',
    order: 5
  }
};


  
  onMounted(async () => {
    if (!mapContainer.value) {
      console.error('mapContainer is not defined')
      return
    }
  
    const width = 800;
    const height = 550;
    const maxHeight = 800;
  
    // create svg that holds the map
    const svg = d3.select(mapContainer.value)
      .append('svg')
      .attr('viewBox', `0 0 ${width} ${height}`)
      .attr('preserveAspectRatio', 'xMidYMid meet')
      .classed('responsive-svg', true);

    mapLayers = svg.append('g').attr('class', 'map-layers')
    updateLayers()  

    
   // update layers whenever visibility changes
   watch(() => props.layerVisibility, updateLayers, { deep: true })
    
  
    // resizing so flexes to page width but stays within reasonable height
    const resizeSvg = () => {
      const containerWidth = mapContainer.value.clientWidth;
      const containerHeight = Math.min(mapContainer.value.clientHeight, maxHeight);
      svg.attr('width', containerWidth).attr('height', containerHeight);
    };
  
    resizeSvg();
    window.addEventListener('resize', resizeSvg);
  
    // svg for stacked bar chart
    const svgBar = d3.select(barContainer.value)
      .append('svg')
      .attr('viewBox', `0 -30 700 100`)
      .attr('preserveAspectRatio', 'xMidYMid meet')
      .classed('bar-chart-svg', true);
  
    let activeRegion = null; // start at national scale
    const g = svgBar.append('g'); // Bar chart container
  
    // updating stacked bar chart to selected region or state
    const updateBarChart = (data, regionName = 'United States') => {
      if (!data.length) return;

      // Sort data based on the order defined in layerPaths
      const sortedData = [...data].sort((a, b) => {
        const normalize = (str) => str.trim().toLowerCase().replace(/\s+/g, '_');
        const orderA = layerPaths[normalize(a.sui_category_5)]?.order || Infinity;
        const orderB = layerPaths[normalize(b.sui_category_5)]?.order || Infinity;
        return orderA - orderB;
      });
      console.log('Sorted data:', sortedData);

      const categories = data.map(d => d.sui_category_5);
      const values = sortedData.map(d => +d.percentage_stress);
  
      const xScale = d3.scaleLinear()
        .domain([0, d3.sum(values)])
        .range([0, 700]);

        const getColor = (category) => {
          const normalizedCategory = category.trim().toLowerCase().replace(/\s+/g, '_');
          return layerPaths[normalizedCategory]?.color || "#ccc"; // Default to gray if no match
        };

  
      g.selectAll('rect')
        .data(data)
        .join(
        enter => enter.append('rect')
            .attr('x', (d, i) => xScale(d3.sum(values.slice(0, i))))
            .attr('y', 0)
            .attr('width', 0) 
            .attr('height', 30)
            .attr('fill', d => getColor(d.sui_category_5))
            .call(enter => enter.transition()
            .duration(750) 
            .attr('width', d => xScale(d.percentage_stress))),
        update => update
            .call(update => update.transition()
            .duration(750)
            .attr('x', (d, i) => xScale(d3.sum(values.slice(0, i))))
            .attr('fill', d => getColor(d.sui_category_5))
            .attrTween('width', function(d, i) {
                const previousWidth = d3.select(this).attr('width') || 0; // fallback to 0 if no prior value
                const interpolator = d3.interpolate(previousWidth, xScale(d.percentage_stress));
                return t => interpolator(t);
            })),
        exit => exit
            .call(exit => exit.transition()
            .duration(750)
            .attr('width', 0) 
            .remove())
        );
 // updating bar chart title with region name
  g.selectAll('text.chart-title')
    .data([regionName])
    .join(
      enter => enter.append('text')
        .attr('class', 'chart-title')
        .attr('x', 0)
        .attr('y', -10)
        .attr('fill', 'black')
        .attr('font-size', '2.5rem')
        .text(regionName),
      update => update.call(update => update.transition()
        .duration(750)
        .text(regionName))
    );

  
      const formatPercentage = d3.format('.0f');
  
      // percent labels on bar chart - currently overlap where very small
      g.selectAll('.chart-labels')
        .data(data, d => d.sui_category_5) // use sui_category_5 as the unique key
        .join(
            enter => {
            const enteringText = enter.append('text')
                .attr('class', 'chart-labels')
                .attr('x', (d, i) => xScale(d3.sum(values.slice(0, i)) + d.percentage_stress / 2))
                .attr('y', 50)
                .attr('fill', 'black')
                .attr('text-anchor', 'middle')
                .text(d => `${formatPercentage(d.percentage_stress)}%`)
                .style('opacity', 0); // start invisible

            enteringText.transition()
                .duration(750)
                .style('opacity', 1); // fade in

            return enteringText;
            },
            update => {
            return update.transition()
                .duration(750)
                .attr('x', (d, i) => xScale(d3.sum(values.slice(0, i)) + d.percentage_stress / 2))
                .text(d => `${formatPercentage(d.percentage_stress)}%`);
            },
            exit => {
            return exit.transition()
                .duration(750)
                .style('opacity', 0)
                .remove(); // fade out and remove
            }
        );

    };
  
    try {
    // read in data
      // region shapes - feature collection
      const topoRegions = await d3.json(import.meta.env.BASE_URL + '/assets/Regions.topojson');
      const geoRegions = topojson.feature(topoRegions, topoRegions.objects[Object.keys(topoRegions.objects)[0]]);

      // CONUS outline - single feature
      const topoUS = await d3.json(import.meta.env.BASE_URL + '/assets/USoutline.topojson');
      const geoUS = topojson.feature(topoUS, topoUS.objects['foo']);

      // water stress stats by region
      const csvData = await d3.csv(import.meta.env.BASE_URL + '/wa_stress_stats.csv');
  
      const projection = d3.geoIdentity().reflectY(true).fitSize([width, height], geoRegions);
      const path = d3.geoPath().projection(projection);
  
      // Overlay the raster images
      const scale_size = 1.2; // scaling pngs because they have an added margin when exported from ggplot
      svg.append('g')
        .selectAll('image')
        .data(layerPaths)
        .enter()
        .append('image')
        .attr('xlink:href', d => import.meta.env.BASE_URL + d)
        .attr('x', -80) // nudging png to fit within svg bounds
        .attr('y', -55) // nudging png to fit within svg bounds
        .attr('width', width * scale_size)
        .attr('height', height * scale_size);
  
    // find national water stress by category
      const totalByCategory = d3.rollups(
        csvData,
        v => d3.sum(v, d => +d.stress_by_reg),
        d => d.sui_category_5
      );
  
      const totalStress = d3.sum(totalByCategory, d => d[1]);
  
      const aggregatedData = totalByCategory.map(([category, value]) => ({
        sui_category_5: category,
        percentage_stress: (value / totalStress) * 100,
      }));
  
      // init bar chart with aggregated data
      updateBarChart(aggregatedData, 'United States');
  
      // draw region boundaries
      const paths = svg.append('g')
        .selectAll('path')
        .data(geoRegions.features)
        .join('path')
        .attr('d', path)
        .attr('class', d => `region ${d.properties.Region_nam_nospace}`)
        .attr('fill', 'transparent')
        .attr("opacity", 0)
        .attr('stroke', 'white')
        .attr('stroke-width', '1px')
        // add interaction to highlight selected region and update bar chart
        .on('mouseover',function(event, d) {
            d3.selectAll('.region')
                .attr('fill','lightgrey')
                .attr('opacity', 0.8)
                .attr('stroke',"black")

            // highlight the selected region with transparent fill
            d3.select(this)
                .attr('fill', 'transparent')
                .attr('opacity', 1)
                .attr('stroke', 'white')
                .attr('stroke-width', '1.5px')
                .raise(); // bring the selected region to the front

            // update the bar chart with the selected region's data
             highlightRegionAndUpdateChart(event, d);

        })
        .on('mouseout', function () {
            // reset all regions to transparent fill and opacity 0
            d3.selectAll('.region')
            .attr('fill', 'transparent')
            .attr('opacity', 0)
            .attr('stroke', 'white')
            .attr('stroke-width', '1.2px');

            // reset bar chart to default aggregated data
            updateBarChart(aggregatedData, 'United States');
        })
        .on('click', (event, d) => {
          activeRegion = d.properties.Region_nam_nospace;
          highlightRegionAndUpdateChart(event, d);
        });
  
    // selection effects and filtering with interaction
      function highlightRegionAndUpdateChart(event, d) {
        
        // update bar chart with regional data
        const regionClassFilter = d.properties.Region_nam;
        const filteredData = csvData
          .filter(row => row.Region_nam === regionClassFilter)
          .map(row => ({
            sui_category_5: row.sui_category_5,
            percentage_stress: (+row.stress_by_reg / d3.sum(csvData.filter(r => r.Region_nam === regionClassFilter), r => +r.stress_by_reg)) * 100,
          }));
  
        updateBarChart(filteredData, `${regionClassFilter} region`);
      }

    // add double outline for CONUS
    svg.append('g')
        .append('path')
        .datum(geoUS)
        .attr("class", "outline-conus")
        .attr('d', path)
        .attr('fill', 'none')
        .attr('stroke', 'grey')
        .attr('stroke-width', '2px');

      // add another outline to regions to make it more visible? idk if this looks great
      svg.append('g')
        .selectAll('path')
        .data(geoRegions.features)
        .join('path')
        .attr('d', path)
        .attr('fill', 'none')
        .attr('stroke', 'white')
        .attr('stroke-width', '0.75px');
  
    } catch (error) {
      console.error('Error loading TopoJSON:', error);
    }
  });
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
    height: auto;
    max-height: 100%;
  }
  
  .bar-chart-svg {
    width: 100%;
    height: auto;
    max-height: 100%;
  }
  .outline-conus {
    filter: drop-shadow(0px 0px 10px rgba(2, 2, 2, 0.5));
  }
  </style>
  