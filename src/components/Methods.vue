<template>
   
    <div class="methods-container"
      v-for="method in thisMethod">
        <button class="accordion">
          <h4 v-html="method.header"></h4><span class="symbol">+</span>
        </button>
        <div class="panel">
            <span v-for="description in method.description">
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
import Methods from './../assets/text/methods.js';

const route = useRoute();

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
      }
    });
  }
});


</script>
  
<style scoped lang="scss">

</style>
  