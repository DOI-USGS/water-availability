<template>
    <div class="text-container">
      <div ref="barContainer" class="bar-container"></div>
    </div>
    <div ref="mapContainer" class="map-container"></div>
  </template>
  
  <script setup>
  import { onMounted, ref, watch, defineProps } from 'vue'
  import * as d3 from 'd3'
  import * as topojson from 'topojson-client'

  const publicPath = import.meta.env.BASE_URL; // this gets the base url for your application
  
  const mapContainer = ref(null)
  const barContainer = ref(null)
  let mapLayers;

// props definition, allowing customized paths and datasets
const props = defineProps({
  layerVisibility: {
    type: Object,
    required: true
  },
  layerPaths: {
    type: Object,
    required: true
  },
  regionsDataUrl: {
    type: String,
    required: true
  },
  regionsVar: {
    type: String,
    required: true
  },
  regionsVarLabel: {
    type: String,
    required: true
  },
  usOutlineUrl: {
    type: String,
    required: true
  },
  csvDataUrl: {
    type: String,
    required: true
  },
  continuousRaw: { 
    type: String,
    required: true
  },
  continuousPercent: { 
    type: String,
    required: true
  },
  categoricalVariable: { 
    type: String,
    required: true
  }
})

const updateLayers = () => {
  if (!mapLayers) return 

  const visibleLayers = Object.entries(props.layerVisibility).map(([key, value]) => ({
    key,
    path: props.layerPaths[key]?.path,
    visible: value
  }))

  mapLayers.selectAll('image')
    .data(visibleLayers, d => d.key) // use key as the identifier
    .join(
      enter => enter.append('image')
        .attr('xlink:href', d => 'https://labs.waterdata.usgs.gov/visualizations/images/water-availability/' + d.path)
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

// watch layerVisibility for changes
watch(
  () => props.layerVisibility,
  () => {
    updateLayers(); // Trigger layer updates
  },
  { deep: true }
);

  
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
        const normalize = (str) => str.trim().toLowerCase().replace(/[\s/\\]+/g, '_');
        const orderA = props.layerPaths[normalize(a[props.categoricalVariable])]?.order || Infinity;
        const orderB = props.layerPaths[normalize(b[props.categoricalVariable])]?.order || Infinity;
        return orderA - orderB;
      });

      const categories = sortedData.map(d => d[props.categoricalVariable]);
      const values = sortedData.map(d => +d[props.continuousPercent]);
  
      const xScale = d3.scaleLinear()
        .domain([0, d3.sum(values)])
        .range([0, 700]);

        const getColor = (category) => {
          const normalizedCategory = category.trim().toLowerCase().replace(/[\s/\\]+/g, '_');
          return props.layerPaths[normalizedCategory]?.color || "#ccc"; // Default to gray if no match
        };

  
      g.selectAll('rect')
        .data(sortedData)
        .join(
        enter => enter.append('rect')
            .attr('x', (d, i) => xScale(d3.sum(values.slice(0, i))))
            .attr('y', 0)
            .attr('width', 0) 
            .attr('height', 30)
            .attr('fill', d => getColor(d[props.categoricalVariable]))
            .call(enter => enter.transition()
            .duration(750) 
            .attr('width', d => xScale(d[props.continuousPercent]))),
        update => update
            .call(update => update.transition()
            .duration(750)
            .attr('x', (d, i) => xScale(d3.sum(values.slice(0, i))))
            .attr('fill', d => getColor(d[props.categoricalVariable]))
            .attrTween('width', function(d, i) {
                const previousWidth = d3.select(this).attr('width') || 0; // fallback to 0 if no prior value
                const interpolator = d3.interpolate(previousWidth, xScale(d[props.continuousPercent]));
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
            .attr('font-size', '2.2rem')
            .attr('font-weight', 'bold')
            .text(regionName),
          update => update.call(update => update.transition()
            .duration(750)
            .text(regionName))
        );

  
      const formatPercentage = d3.format('.0f');
  
      // percent labels on bar chart - currently overlap where very small
      g.selectAll('.chart-labels')
        .data(sortedData, d => d[props.categoricalVariable]) // unique key
        .join(
            enter => {
            const enteringText = enter.append('text')
                .attr('class', 'chart-labels')
                .attr('x', (d, i) => xScale(d3.sum(values.slice(0, i)) + d[props.continuousPercent] / 2))
                .attr('y', 50)
                .attr('fill', 'black')
                .attr('text-anchor', 'middle')
                .text(d => `${formatPercentage(d[props.continuousPercent])}%`)
                .style('opacity', 0); // start invisible

            enteringText.transition()
                .duration(750)
                .style('opacity', 1); // fade in

            return enteringText;
            },
            update => {
              return update.transition()
                  .duration(750)
                  .attr('x', (d, i) => xScale(d3.sum(values.slice(0, i)) + d[props.continuousPercent] / 2))
                  .text(d => `${formatPercentage(d[props.continuousPercent])}%`);
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
      const topoRegions = await d3.json(`${publicPath}${props.regionsDataUrl}`);
      const geoRegions = topojson.feature(topoRegions, topoRegions.objects[Object.keys(topoRegions.objects)[0]]);

      // CONUS outline - single feature
      const topoUS = await d3.json(props.usOutlineUrl);
      const geoUS = topojson.feature(topoUS, topoUS.objects['foo']);

      // water stats by region
      const csvData = await d3.csv(`${publicPath}${props.csvDataUrl}`);
  
      const projection = d3.geoIdentity().reflectY(true).fitSize([width, height], geoRegions);
      const path = d3.geoPath().projection(projection);
  
      // Overlay the raster images
      const scale_size = 1.2; // scaling pngs because they have an added margin when exported from ggplot
      svg.append('g')
        .selectAll('image')
        .data(props.layerPaths)
        .enter()
        .append('image')
        .attr('xlink:href', d => import.meta.env.BASE_URL + d)
        .attr('x', -80) // nudging png to fit within svg bounds
        .attr('y', -55) // nudging png to fit within svg bounds
        .attr('width', width * scale_size)
        .attr('height', height * scale_size);
  
    // find national stats by category
      const totalByCategory = d3.rollups(
        csvData,
        v => d3.sum(v, d => +d[props.continuousRaw]),
        d => d[props.categoricalVariable]
      );
  
      const totalValue = d3.sum(totalByCategory, d => d[1]);
  
      const aggregatedData = totalByCategory.map(([category, value]) => ({
        [props.categoricalVariable]: category,
        d3_percentage: (value / totalValue) * 100,
      }));
  
      // init bar chart with aggregated data
      updateBarChart(aggregatedData, 'United States');
  
      // draw region boundaries
      const paths = svg.append('g')
        .selectAll('path')
        .data(geoRegions.features)
        .join('path')
        .attr('d', path)
        .attr('class', d => `region ${d[props.RegionsVar]}`)
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
          activeRegion = d[props.RegionsVar];
          highlightRegionAndUpdateChart(event, d);
        });
  
    // selection effects and filtering with interaction
      function highlightRegionAndUpdateChart(event, d) {
        
        // update bar chart with regional data
        const regionClassFilter = d.properties.Region_nam;
        const filteredData = csvData
          .filter(row => row.Region_nam === regionClassFilter)
          .map(row => ({
            d3_category: row[props.categoricalVariable],
            d3_percentage: (+row[props.continuousRaw] / d3.sum(csvData.filter(r => r.Region_nam === regionClassFilter), r => +r[props.continuousRaw])) * 100,
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
  