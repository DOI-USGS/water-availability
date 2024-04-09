<template>
  <section>
    <div class="wavy-container">
      <div class="key-message-container">
        <p>2024 National Integrated Water Availability Assessments</p>
        <h2>Key Messages</h2>
      </div>
    </div>
    <div class="raindrop-container">
      <div class="key-message-item"> 
        <router-link to="/page1">
          <button class="raindrop"><span class="raindrop-text">1</span></button>
        </router-link><br>
        <div class="key-message-item-text">
          This report provides the Nation with the first comprehensive assessment of water availability that is inclusive of water quantity, use, and quality.
        </div>
      </div>
      
      <div class="key-message-item"> 
        <router-link to="/page2">
          <button class="raindrop"><span class="raindrop-text">2</span></button>
        </router-link><br>
        <div class="key-message-item-text">
          At the national scale, water supply is larger than demand. At regional scales, demand is sometimes larger than supply. 
        </div>
      </div>

      <div class="key-message-item"> 
        <router-link to="/page3">
          <button class="raindrop"><span class="raindrop-text">3</span></button>
        </router-link><br>
        <div class="key-message-item-text">
          Almost 10% of the nation (29.6 million people) live in areas of high or severe water stress. 
        </div>
      </div>

      <div class="key-message-item"> 
        <router-link to="/page4">
          <button class="raindrop"><span class="raindrop-text">4</span></button>
        </router-link><br>
        <div class="key-message-item-text">
          The relative importance of public supply, crop irrigation, and thermoelectric water supply varies regionally.
        </div>
      </div>

      <div class="key-message-item"> 
        <router-link to="/page5">
          <button class="raindrop"><span class="raindrop-text">5</span></button>
        </router-link><br>
        <div class="key-message-item-text">
          The source of public supply water use varies from west to east across the country.
        </div>
      </div>

      <div class="key-message-item"> 
        <router-link to="/page6">
          <button class="raindrop"><span class="raindrop-text">6</span></button>
        </router-link><br>
        <div class="key-message-item-text">
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
        </div>
      </div>

      <div class="key-message-item"> 
        <router-link to="/page7">
          <button class="raindrop"><span class="raindrop-text">7</span></button>
        </router-link><br>
        <div class="key-message-item-text">
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
        </div>
      </div>

      <div class="key-message-item"> 
        <router-link to="/page8">
          <button class="raindrop"><span class="raindrop-text">8</span></button>
        </router-link><br>
        <div class="key-message-item-text">
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
        </div>
      </div>

      <div class="key-message-item"> 
        <router-link to="/page9">
          <button class="raindrop"><span class="raindrop-text">9</span></button>
        </router-link><br>
        <div class="key-message-item-text">
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
        </div>
      </div>

      <div class="key-message-item"> 
        <router-link to="/page10">
          <button class="raindrop"><span class="raindrop-text">10</span></button>
        </router-link><br>
        <div class="key-message-item-text">
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
        </div>
      </div>

  </div>
  </section>
</template>

<script setup>
  //import Wavy from '../components/WavyWaves.vue';
</script>

<style scoped>
.section-header {
  color: var(--dodger-blue);
}

.raindrop-container {
  height: 100vh;
}

.key-message-item {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 10px;
}

.key-message-item-text {
  margin-left: 20px;
  color: #5e7789;
  width: 75%;
}

.raindrop {
  width: 50px;
  height: 50px;
  border-radius: 0 50% 50% 50%;
  border: 0px;
  transform: rotate(45deg);
  margin-top: 20px;
  background-color: #DAD6CA;
}

.raindrop:hover {
  cursor: pointer;
  background-color: #C4C0B4;
}

.raindrop-text {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) rotate(-45deg);
  color: #5e7789;
  font-size: 40px;
  font-weight: bold;
}

</style>