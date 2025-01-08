<template>
    <div class="legend_wrap" :id="legendId">
      <label class="legend_item">
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
  display: flex;
  align-items: center;
  white-space: nowrap; /* Prevent wrapping inside each item */
  padding-bottom: 4px;
}

.legend_wrap {
  display: flex;
  align-items: center;
}

.legend_mark {
  width: 30px;
  height: 30px;
  display: inline-block;
  margin-right: 8px;
  border-radius: 4px;
   box-shadow:0 0 0 0px #000, 0 0 0 1px #000 inset;
  -khtml-box-shadow: 0 0 0 0px #000, 0 0 0 1px #000 inset;
  -moz-box-shadow: 0 0 0 0px #000, 0 0 0 1px #000 inset;
  -webkit-box-shadow: 0 0 0 0px #000, 0 0 0 1px #000 inset;
}
  </style>
  