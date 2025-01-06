<template>
    <div class="legend_item" :id="legendId">
      <label class="legend_wrap chart-text">
        <input type="legend" name="legend" class="legend-inp">
        <span class="legend_mark" :style="{ backgroundColor: color }"></span>
        {{ label }}
      </label>
    </div>
  </template>
  
  <script setup>
  import { defineProps } from 'vue';
  
  // define props
  const props = defineProps({
    legendId: {
      type: String,
      required: true
    },
    label: {
      type: String,
      required: true
    },
    color: {
      type: String,
      required: true
    }
  });
  </script>
  
  <style scoped>
  .legend_item {
  margin: 0 10px; /* Add horizontal margin between items */
  display: flex;
  align-items: center;
  white-space: nowrap; /* Prevent wrapping inside each item */
}

.legend_wrap {
  display: flex;
  align-items: center;
}

.legend_mark {
  width: 16px;
  height: 16px;
  display: inline-block;
  margin-right: 8px;
  border-radius: 2px;
}
  </style>
  