<template>
    <div class="methods-container">
        <button class="accordion">
          <span>Learn about the methods</span><span class="symbol">+</span>
        </button>
        <div class="panel">
            <p v-html="thisMethod"></p>
        </div>
    </div>


</template>
  
<script setup>
import { computed, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import SubPages from './SubPages';
import Methods from './../assets/text/methods.js';

const route = useRoute();

const path = computed(() => route.path)

// filter to this page's key message
const methodArray = Methods.key.filter(message => message.route === route.path);
const thisMethod = methodArray[0].description;

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
.accordion {
  background-color: var(--blue-light);
  color: var(--blue-dark);
  cursor: pointer;
  padding: 16px;
  width: 100%;
  border: none;
  text-align: left;
  outline: none;
  line-height: 1.2;
  transition: 0.4s;
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 2.15rem;
  font-family: 'Source Sans Pro', sans-serif;
  font-weight: 600;
  position: relative;
  border: 2px solid transparent;
  margin-bottom: 8px
}

.accordion::before {
  content: "";
  position: absolute;
  top: -2px;
  left: -2px;
  right: -2px;
  bottom: -2px;
  border: 2px solid transparent;
  z-index: -1;
  transition: border-color 0.3s;
}

.accordion:hover::before, .accordion.active::before {
  border-color: var(--cream-background);
}

.active, .accordion:hover {
  background-color: var(--teal-dark); 
  color: white;
}

.panel {
  display: none; 
  overflow: hidden;
  border: 3px solid var(--blue-light); 
  margin-bottom: 15px;
  margin-top: -15px;
  border-top-width: 0;
  border-radius: 0 0 10px 10px;
}

.panel p {
  margin: 20px;
}
  
.symbol {
  font-size: 32px;
  font-weight: bold;
}

</style>
  