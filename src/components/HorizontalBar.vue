<template>
    <div class="chart-container" >
      <div ref="barContainer" class="bar-container" id="bar-container"></div>
    </div>  
</template>
  
  <script setup>
  import { onMounted, ref, watch, inject } from 'vue';
  import * as d3 from 'd3';
  import { isMobile, mobileVendor } from 'mobile-device-detect';

  const animateTime = inject('animateTime')
  const mobileView = isMobile;
  let width, height, marginLeft, marginRight;

  // props to configure the bar chart
  const props = defineProps({
    categoricalVariable: { type: String, required: true },
    continuousPercent: { type: String, required: true },
    continuousRaw: { type: String, required: true },
    layerPaths: { type: Object, required: true },
    data: { type: Array, required: true },
    regionName: { type: String, default: 'lower 48 United States' },
  });
  
  const barContainer = ref(null);
  let svgBar;
  
onMounted(() => {
  // create the SVG if it doesn't exist
  width = mobileView ? 320 : 600;
  height = 100;
  marginLeft = mobileView ? 120 : 100;
  marginRight = mobileView ? 10 : 100;

  if (!svgBar) {
    svgBar = d3.select(barContainer.value)
      .append('svg')
        .attr('width', width)
        .attr('height', height)
        .attr('viewBox', `0 0 ${width} ${height}`)
        .attr('preserveAspectRatio', 'xMidYMid meet')
        .attr('class', 'bar-chart-svg')

    svgBar.append('g'); // add a <g> container

  }

  const aggregatedData = aggregateData(props.data);
  updateBarChart(aggregatedData);
});

//  aggregate data for the US
const aggregateData = (data) => {
  const totalByCategory = d3.rollups(
    data,
    (v) => d3.sum(v, (d) => +d[props.continuousRaw]),
    (d) => d[props.categoricalVariable]
  );

  return totalByCategory.map(([category, value]) => ({
    [props.categoricalVariable]: category,
    [props.continuousRaw]: value,
  }));
};

const updateBarChart = (data) => {
  if (!data.length) {
    console.warn('No data provided for the bar chart.');
    return;
  }

  const allCategories = Object.keys(props.layerPaths).map(key => ({
    [props.categoricalVariable]: key,
    [props.continuousRaw]: 0, // Default value for missing categories
  }));

  // Merge all categories with current data
  const completeData = allCategories.map(category => {
    const current = data.find(d => d[props.categoricalVariable] === category[props.categoricalVariable]);
    return current ? current : category; // Use current data if it exists, otherwise use default
  });

   const yScale = d3.scaleBand()
    .domain(data.map(d => d[props.categoricalVariable]))
    .range([0, height])
    .padding(0.6); // between bars

  // Currently using a static max for x-axis
  const xScale = d3.scaleLinear()
    .domain([0, 125000])
    .range([marginLeft, width - marginLeft - marginRight]);

  const getColor = (category) => {
    const normalizedCategory = category.trim().toLowerCase().replace(/[\s/\\]+/g, '_');
    return props.layerPaths[normalizedCategory]?.color || '#ccc'; // default color
  };

  const g = svgBar.select('g'); // reuse the <g> container

  // create and update rectangles
  g.selectAll('rect')
    .data(completeData, d => d[props.categoricalVariable])
    .join(
      enter => enter.append('rect')
        .attr('y', d => yScale(d[props.categoricalVariable]))
        .attr('x', marginLeft) 
        .attr('height', yScale.bandwidth())
        .attr('width', 0) 
        .attr('fill', d => getColor(d[props.categoricalVariable]))
        .call(enter => enter.transition().duration(animateTime)
          .attr('width', d => xScale(d[props.continuousRaw]))
        ),
      update => update.transition().duration(animateTime)
        .attr('y', d => yScale(d[props.categoricalVariable]))
        .attr('x', marginLeft)
        .attr('width', d => xScale(d[props.continuousRaw]))
        .attr('fill', d => getColor(d[props.categoricalVariable])),
        exit => exit
            .call(exit => exit.transition()
            .attr('width', 0) 
            .remove())
    );

  
    g.selectAll('#category-label')
    .data(completeData, d => d[props.categoricalVariable])
        .join(
        enter => enter.append('text')
            .attr('id', 'category-label')
            .attr('class', 'axis-text')
            .attr('x', marginLeft - 10) // Adjust for left alignment
            .attr('y', d => yScale(d[props.categoricalVariable]) + yScale.bandwidth() / 2)
            .attr('dy', '0.35em') // Vertical alignment
            .attr('text-anchor', 'end') 
            .text(d => {
                const categoryKey = d[props.categoricalVariable].trim().toLowerCase().replace(/[\s/\\]+/g, '_');
                return props.layerPaths[categoryKey]?.label || d[props.categoricalVariable]; // Fallback to category name
            }),
          update => update.transition().duration(animateTime)
            .attr('y', d => yScale(d[props.categoricalVariable]) + yScale.bandwidth() / 2)
            .text(d => {
                const categoryKey = d[props.categoricalVariable].trim().toLowerCase().replace(/[\s/\\]+/g, '_');
                return props.layerPaths[categoryKey]?.label || d[props.categoricalVariable]; // Fallback to category name
            }),
          exit => exit.transition().duration(animateTime) 
            .style('opacity', 0)
            .remove()
          );

    g.selectAll('#value-label')
        .data(completeData, d => d[props.categoricalVariable]) // Bind data with a unique key
        .join(
            enter => enter.append('text')
              .attr('id', 'value-label')
              .attr('class', 'axis-text')
              .attr('x', d => xScale(d[props.continuousRaw]) + marginLeft + 10) 
              .attr('y', d => yScale(d[props.categoricalVariable]) + yScale.bandwidth() / 2)
              .attr('dy', '0.35em') 
              .attr('text-anchor', 'start') 
              .attr('fill', 'black')
              .text(d => formatValue(d[props.continuousRaw])), 
            update => update.transition().duration(animateTime)
              .attr('class', 'axis-text')
              .attr('x', d => xScale(d[props.continuousRaw]) + marginLeft + 10) 
              .attr('y', d => yScale(d[props.categoricalVariable]) + yScale.bandwidth() / 2)
              .text(d => formatValue(d[props.continuousRaw])), 
            exit => exit.transition().duration(animateTime) 
              .style('opacity', 0)
              .remove()
        );



};
const formatValue = (value) => {
  return Math.round(value).toLocaleString(); // round and format with commas
};

// watch for changes in data or regionName
watch(
    () => [props.data, props.regionName], 
    ([data, regionName]) => {
        const filteredData =
        regionName === 'lower 48 United States'
        ? data
        : data.filter(d => d.Region_nam === regionName)

  updateBarChart(filteredData);
});
</script>

<style>
.bar-chart-svg {
    width: 100%;
    overflow: visible;
}
@media only screen and (max-width: 600px) {
  .bar-chart-svg {
    width: 95vw;
    max-width: 95vw;
  }
} 
  </style>