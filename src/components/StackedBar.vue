<template>
    <div class="chart-container">
    <div ref="barContainer" class="bar-container"></div>
</div>  
</template>
  
  <script setup>
  import { onMounted, ref, watch, defineProps } from 'vue';
  import * as d3 from 'd3';
  
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
  if (!svgBar) {
    svgBar = d3.select(barContainer.value)
      .append('svg')
      .attr('viewBox', `0 -30 700 100`)
      .attr('preserveAspectRatio', 'xMidYMid meet')
      .classed('bar-chart-svg', true);

    svgBar.append('g'); // add a <g> container

    svgBar.select('g').append('text')
      .attr('class', 'chart-subtitle')
      .attr('x', 0)
      .attr('y', 10)
      .text(`Bars show what percent of the region has very low, low, moderate, high, and severe water limitation.`)
  }

  const aggregatedData = aggregateData(props.data);
  updateBarChart(aggregatedData, 'lower 48 United States');
});

//  aggregate data for the US
const aggregateData = (data) => {
  const totalByCategory = d3.rollups(
    data,
    (v) => d3.sum(v, (d) => +d[props.continuousRaw]),
    (d) => d[props.categoricalVariable]
  );

  const totalValue = d3.sum(totalByCategory, (d) => d[1]);

  return totalByCategory.map(([category, value]) => ({
    [props.categoricalVariable]: category,
    [props.continuousPercent]: (value / totalValue) * 100,
  }));
};

const updateBarChart = (data, regionName) => {
  if (!data.length) {
    console.warn('No data provided for the bar chart.');
    return;
  }

  // sort data based on the order defined in layerPaths
  const sortedData = [...data].sort((a, b) => {
    const normalize = (str) => str.trim().toLowerCase().replace(/[\s/\\]+/g, '_');
    const orderA = props.layerPaths[normalize(a[props.categoricalVariable])]?.order || Infinity;
    const orderB = props.layerPaths[normalize(b[props.categoricalVariable])]?.order || Infinity;
    return orderA - orderB;
  });

  const values = sortedData.map(d => +d[props.continuousPercent]);
  const xScale = d3.scaleLinear()
    .domain([0, d3.sum(values)])
    .range([0, 700]);

  const getColor = (category) => {
    const normalizedCategory = category.trim().toLowerCase().replace(/[\s/\\]+/g, '_');
    return props.layerPaths[normalizedCategory]?.color || '#ccc'; // default color
  };

  const g = svgBar.select('g'); // reuse the <g> container

  // create and update rectangles
  g.selectAll('rect')
    .data(sortedData)
    .join(
      enter => enter.append('rect')
        .attr('x', (d, i) => xScale(d3.sum(values.slice(0, i))))
        .attr('y', 20)
        .attr('width', 0)
        .attr('height', 30)
        .attr('fill', d => getColor(d[props.categoricalVariable]))
        .call(enter => 
            enter.transition()
            .duration(750)
            .attr('width', d => xScale(d[props.continuousPercent]))),
      (update) => update.transition()
        .duration(750)
        .attr('x', (d, i) => xScale(d3.sum(values.slice(0, i))))
        .attr('fill', d => getColor(d[props.categoricalVariable]))
        .attrTween('width', function(d, i) {
                const previousWidth = d3.select(this).attr('width') || 0; // fallback to 0 if no prior value
                const interpolator = d3.interpolate(previousWidth, xScale(d[props.continuousPercent]));
                return t => interpolator(t);
            }),
        exit => exit
            .call(exit => exit.transition()
            .duration(750)
            .attr('width', 0) 
            .remove())
    );

  // update chart title
  const displayTitle = regionName === 'lower 48 United States' ? regionName : `${regionName} Region`;

    g.selectAll('text.chart-title')
    .data([regionName])
    .join(
      enter => enter.append('text')
        .attr('class', 'chart-title')
        .attr('x', 0)
        .attr('y', -10)
        .text(`Water limitation in the ${displayTitle}`),
        //.text(displayTitle),
      update => update.transition()
        .duration(750)
        .text(`Water limitation in the ${displayTitle}`)
    );

    const formatPercentage = d3.format('.0f');
  
      // percent labels on bar chart 
      g.selectAll('.percent-label')
        .data(sortedData, d => d[props.categoricalVariable]) // unique key
        .join(
            enter => {
            const enteringText = enter.append('text')
                .attr('class', 'percent-label')
                .attr('x', (d, i) => xScale(d3.sum(values.slice(0, i)) + d[props.continuousPercent] / 2))
                .attr('y', 65)
                .attr('text-anchor', 'middle')
                .text(d => `${formatPercentage(d[props.continuousPercent])}%`)
                .style('opacity', 0); // start invisible

            enteringText.transition()
                .duration(750)
                .style('opacity', d => (d[props.continuousPercent] > 1 ? 1 : 0));; // fade in

            return enteringText;
            },
            update => {
              return update.transition()
                  .duration(750)
                  .attr('x', (d, i) => xScale(d3.sum(values.slice(0, i)) + d[props.continuousPercent] / 2))
                  .text(d => `${formatPercentage(d[props.continuousPercent])}%`)
                  .style('opacity', d => (d[props.continuousPercent] > 1 ? 1 : 0));;
            },
            exit => {
              return exit.transition()
                  .duration(750)
                  .style('opacity', 0)
                  .remove(); // fade out and remove
            }
        );


};

// watch for changes in data or regionName
watch(
    () => [props.data, props.regionName], 
    ([data, regionName]) => {
        const filteredData =
        regionName === 'lower 48 United States'
        ? aggregateData(data)
        : data.filter(d => d.Region_nam === regionName)

  updateBarChart(filteredData, regionName);
});
</script>

<style>
.bar-chart-svg {
    width: 100%;
    height: auto;
    max-height: 100%;
  }
  </style>