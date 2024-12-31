<template>
    <div class="chart-container">
    <div ref="barContainer" class="bar-container"></div>
</div>  
</template>
  
  <script setup>
  import { onMounted, ref, watch, defineProps, inject } from 'vue';
  import * as d3 from 'd3';

  const animateTime = inject('animateTime')

  // props to configure the bar chart
  const props = defineProps({
    categoricalVariable: { type: String, required: true },
    continuousPercent: { type: String, required: true },
    continuousRaw: { type: String, required: true },
    layerPaths: { type: Object, required: true },
    data: { type: Array, required: true },
    regionName: { type: String, default: 'United States' },
  });
  
  const barContainer = ref(null);
  let svgBar;
  
onMounted(() => {
  // create the SVG if it doesn't exist
  if (!svgBar) {
    svgBar = d3.select(barContainer.value)
      .append('svg')
      .attr('viewBox', `0 0 700 150`)
      .attr('preserveAspectRatio', 'xMidYMid meet')
      .classed('bar-chart-svg', true);

    svgBar.append('g'); // add a <g> container

    svgBar.select('g').append('text')
      .attr('class', 'chart-text')
      .attr('x', 0)
      .attr('y', 45)
      .text(`Total water use for the top four water use categories in the U.S. in ??million gallons per year??`)
  }

  const aggregatedData = aggregateData(props.data);
  updateBarChart(aggregatedData, 'United States');
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

const updateBarChart = (data, regionName) => {
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

  /// Define dimensions and scales
  const chartHeight = 140; 

   const yScale = d3.scaleBand()
    .domain(data.map(d => d[props.categoricalVariable]))
    .range([45, chartHeight])
    .padding(0.6); // between bars

  // Currently using a static max for x-axis
  const xScale = d3.scaleLinear()
    .domain([0, 125000])
    .range([0, 700-160]);

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
        .attr('x', 160) 
        .attr('height', yScale.bandwidth())
        .attr('width', 0) 
        .attr('fill', d => getColor(d[props.categoricalVariable]))
        .call(enter => enter.transition().duration(animateTime)
          .attr('width', d => xScale(d[props.continuousRaw]))
        ),
      update => update.transition().duration(animateTime)
        .attr('y', d => yScale(d[props.categoricalVariable]))
        .attr('x', 160)
        .attr('width', d => xScale(d[props.continuousRaw]))
        .attr('fill', d => getColor(d[props.categoricalVariable])),
        exit => exit
            .call(exit => exit.transition()
            .attr('width', 0) 
            .remove())
    );

  // update chart title
  const displayTitle = regionName === 'United States' ? regionName : `${regionName} Region`;
  g.selectAll('text.chart-title')
    .data([regionName])
    .join(
      enter => enter.append('text')
        .attr('class', 'chart-title')
        .attr('x', 0)
        .attr('y', 25)
        .text(`Water use in the ${displayTitle}`),
      update => update
        .transition()
        .duration(animateTime)
        .text(`Water use in the ${displayTitle}`)
    );

    g.selectAll('.category-label')
    .data(completeData, d => d[props.categoricalVariable])
        .join(
        enter => enter.append('text')
            .attr('class', 'category-label')
            .attr('x', 150) // Adjust for left alignment
            .attr('y', d => yScale(d[props.categoricalVariable]) + yScale.bandwidth() / 2)
            .attr('dy', '0.35em') // Vertical alignment
            .attr('text-anchor', 'end') 
            .attr('font-size', '1.5rem')
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

    g.selectAll('.value-label')
        .data(completeData, d => d[props.categoricalVariable]) // Bind data with a unique key
        .join(
            enter => enter.append('text')
            .attr('class', 'value-label')
            .attr('x', d => xScale(d[props.continuousRaw]) + 165) 
            .attr('y', d => yScale(d[props.categoricalVariable]) + yScale.bandwidth() / 2)
            .attr('dy', '0.35em') 
            .attr('text-anchor', 'start') 
            .attr('font-size', '1.5rem')
            .attr('fill', 'black')
            .text(d => formatValue(d[props.continuousRaw])), 
            update => update.transition().duration(animateTime)
            .attr('x', d => xScale(d[props.continuousRaw]) + 165) 
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
        regionName === 'United States'
        ? data
        : data.filter(d => d.Region_nam === regionName)

  updateBarChart(filteredData, regionName);
});
</script>

<style>
.bar-chart-svg {
    width: 100%;
    height: auto;
    max-height: 100%;
    overflow: visible;
  }
  </style>