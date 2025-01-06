<template>
  <div class="checkbox_wrap toggle-container">
    <label class="toggle-label">
      <!-- Left label for either/or use case -->
      <span 
        v-if="leftLabel" 
        class="toggle-text" 
        :class="{ tactive: !modelValue }"
      >
        {{ leftLabel }}
      </span>
      
      <!-- Toggle switch -->
      <input 
        type="checkbox" 
        class="toggle-input" 
        :checked="modelValue"
        @change="$emit('update:modelValue', !modelValue)"
      />
      <span 
       class="toggle-slider"
       :style="{ backgroundColor: modelValue ? rightColor : leftColor }"
       ></span>

      <!-- Right label for either/or use case or single toggle label -->
      <span 
        v-if="rightLabel" 
        class="toggle-text" 
        :class="{ tactive: modelValue, inactive: !modelValue }"
      >
      {{ rightLabel }}
    </span>
     <!-- Single label -->
     <span 
        v-else-if="label" 
        class="toggle-text"
        :class="{ tactive: modelValue, inactive: !modelValue }"
      >
        {{ label }}
      </span>
    </label>
  </div>
</template>

<script setup>
defineProps({
  modelValue: Boolean, // v-model binding for toggle state

  // optional props for either/or labels
  leftLabel: {
    type: String,
    required: false
  },
  rightLabel: {
    type: String,
    required: false
  },

  // optional prop for single label (on/off use case)
  label: {
    type: String,
    required: false
  },
  // colors for each label and inactive state
  leftColor: {
    type: String,
    default: 'var(--inactive-grey)' 
  },
  rightColor: {
    type: String,
    default: 'var(--soft-black)' 
  },
  inactiveColor: {
    type: String,
    default: 'var(--inactive-grey)' 
  }
});

defineEmits(['update:modelValue']);
</script>

<style scoped>

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

/* text styles */
.toggle-text {
  transition: color 0.3s ease;
  color: var(--inactive-grey);
}

.toggle-text.tactive {
  color: var(--black-soft); /* active label is black */
}
.toggle-input:focus-visible {
  outline: none; /* removes focus outline */
}

.toggle-label:focus-visible {
  outline: none; /* removes focus outline */
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
