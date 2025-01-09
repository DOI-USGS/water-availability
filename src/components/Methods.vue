<template>
   
    <div class="methods-container"
      v-for="method in thisMethod">
        <button class="accordion">
          <h4 v-html="method.header"></h4><span class="symbol">+</span>
        </button>
        <div class="panel">
            <span v-for="description in method.description">
              <p v-html="description.text"></p>
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
  