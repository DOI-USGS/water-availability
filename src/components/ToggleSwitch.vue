<template>
    <div class="checkbox_wrap toggle-container">
      <label class="toggle-label">
        <!-- Left label -->
        <span class="toggle-text" :class="{ active: !modelValue }">{{ leftLabel }}</span>
  
        <!-- Toggle switch -->
        <input 
          type="checkbox" 
          class="toggle-input" 
          :checked="modelValue"
          @change="$emit('update:modelValue', !modelValue)"
        />
        <span class="toggle-slider"></span>
  
        <!-- Right label -->
        <span class="toggle-text" :class="{ active: modelValue }">{{ rightLabel }}</span>
      </label>
    </div>
  </template>
  
  <script setup>
  defineProps({
    modelValue: Boolean, // v-model binding for toggle state
    leftLabel: {
      type: String,
      required: true
    },
    rightLabel: {
      type: String,
      required: true
    }
  });
  
  defineEmits(['update:modelValue']);
  </script>
  
  <style scoped>
  /* toggle container */
  .toggle-container {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
  }
  
  /* toggle label for positioning */
  .toggle-label {
    display: flex;
    align-items: center;
    gap: 8px;
    cursor: pointer;
    position: relative;
  }
  
  /* text styles for words on left and right */
  .toggle-text {
    font-size: 16px;
    font-weight: 600;
    transition: color 0.3s ease;
    color: var(--black-soft);
  }
  
  .toggle-text.active {
    color: var(--blue-bright); /* highlighted color */
  }
  
  /* toggle input (hidden) */
  .toggle-input {
    display: none;
  }
  
  /* toggle slider styles */
  .toggle-slider {
    position: relative;
    width: 40px;
    height: 20px;
    background-color: lightgrey;
    border-radius: 20px;
    transition: background-color 0.3s ease;
  }
  
  .toggle-slider::before {
    content: "";
    position: absolute;
    width: 16px;
    height: 16px;
    background-color: white;
    border-radius: 50%;
    top: 2px;
    left: 2px;
    transition: transform 0.3s ease;
  }
  
  /* move slider to the right when checked */
  .toggle-input:checked + .toggle-slider::before {
    transform: translateX(20px);
  }
  
  /* change slider background when checked */
  .toggle-input:checked + .toggle-slider {
    background-color: var(--blue-bright);
  }
  </style>
  