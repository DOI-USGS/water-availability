<template>
    <div class="methods-container"
      v-for="method, index in thisMethod" :key="index">
        <button class="accordion">
          <h4 v-html="method.header"></h4><span class="symbol">+</span>
        </button>
        <div class="panel">
            <span v-for="description, index in method.description" :key="index">
              <p>
                <span v-html="description.text"></span>
                  <span v-for="reference, index in theseReferences.filter(item => `${description.refs}`.includes(item.refID))" :key="index" class="tooltip">   
                          <sup class="in-text-number">{{ reference.referenceNumber }} </sup> 
                          <span class="tooltiptext">
                            <span v-html="reference.label" />
                          </span>
                          <span v-if="index < theseReferences.filter(item => `${description.refs}`.includes(item.refID)).length - 1">
                            <sup class="in-text-number">,&nbsp;
                            </sup>
                          </span>

                  </span>
              </p>
              
              
            </span>
        </div>
    </div>
</template>
  
<script setup>
import { onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { useWindowSizeStore } from '../stores/WindowSizeStore';
import Methods from '../assets/text/methods.js';

const route = useRoute();
const windowSizeStore = useWindowSizeStore();

// filter to this page's key message
const methodArray = Methods.key.filter(message => message.route === route.path);
const thisMethod = methodArray[0].method;

defineProps({
  theseReferences: {
    type: Array,
    required: true
  }
});

// Accordion click handler
onMounted(() => {
  const acc = document.getElementsByClassName("accordion");
  for (let i = 0; i < acc.length; i++) {
    acc[i].addEventListener("click", function () {
      this.classList.toggle("active");
      const panel = this.nextElementSibling;
      const symbol = this.querySelector('.symbol');
      if (panel.style.display === "block") {
        panel.style.display = "none";
        symbol.textContent = "+";
      } else {
        panel.style.display = "block";
        symbol.textContent = "-";

        // re-position tooltips that go off screen
        let refTooltips = panel.querySelectorAll(".tooltip");
        refTooltips.forEach(tooltip => position_tooltip(tooltip))
      }
    });
  }
});

function position_tooltip(tooltip_group){
  // Get .tooltiptext sibling
  const tooltip = tooltip_group.querySelector(".tooltiptext");
  
  // Get calculated tooltip coordinates and size
  const tooltip_rect = tooltip.getBoundingClientRect();
  
  // Corrections if out of window
  let tipX = 0;
  if ((tooltip_rect.x + tooltip_rect.width) > windowSizeStore.windowWidth) {// Out on the right
    tipX = -tooltip_rect.width - 5;  // Simulate a "right: tipX" position
  }

  // Apply corrected position
  tooltip.style.left = tipX + 'px';
}
</script>
  
<style scoped lang="scss">

</style>
  