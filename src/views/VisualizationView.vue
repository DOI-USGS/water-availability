<template>
  <section>
    <div class="wavy-container">
      <div class="title-message-container">
        <h2 id="main-title">Water availability in the United States</h2>
      </div>
      <section>
        <div class="waves">
          <div class="wave" id="wave1"></div>
          <div class="wave" id="wave2"></div>
          <div class="wave" id="wave3"></div>
          <div class="wave" id="wave4"></div>
        </div>
      </section>
    </div>
    <div id="findings-container">
      <div class="raindrop-container">
        <div class="key-message-item" v-for="(message, index) in SubPages.SubPages" :key="index">
          <div v-if="featureToggles.keyFindingToggles[`keyFinding${index + 1 < 10 ? `0${index + 1}` : index + 1}`]">
              <router-link :to="message.route">
                <button class="raindrop"><span class="raindrop-text"> {{ message.page }}</span></button>
              </router-link><br>
            </div>
          <div class="key-message-item-text">
            <h3> {{ message.mainTitle }} </h3>
            <h4> {{ message.shortTitle }}</h4>
          </div>
        </div>
    </div>
    </div>
    <section class="wavy-container bottom-wavy">
      <section>
        <div class="waves upside-down">
          <div class="wave" id="wave1"></div>
          <div class="wave" id="wave2"></div>
          <div class="wave" id="wave3"></div>
          <div class="wave" id="wave4"></div>
        </div>
      </section>
      <div class="title-message-container">
        <div 
          v-if="featureToggles.showReportLinks" 
          class="report-link-container">
        <a href="labs.waterdata.usgs.gov/visualizations" target="_blank" rel="noopener noreferrer" class="report-link">
         <h3> Read the report</h3>
        </a>        <a href="labs.waterdata.usgs.gov/visualizations" target="_blank" rel="noopener noreferrer" class="report-link">
         <h3> Access the data</h3>
        </a>
        </div>
      </div>
    </section>
  </section>
</template>

<script setup>
  import { reactive } from 'vue';
  import SubPages from '@/components/SubPages.js';

  // reactive feature toggles
  const featureToggles = reactive({
    keyFindingToggles: {
      keyFinding01: false,
      keyFinding02: false,
      keyFinding03: false,
      keyFinding04: false,
      keyFinding05: false,
      keyFinding06: true,
      keyFinding07: true,
      keyFinding08: true,
      keyFinding09: true,
      keyFinding10: true,
    },
    showReportLinks: true,
  });
</script>

<style scoped>


/* text box within the wavy container that houses key messages */
.title-message-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding: 100px 20px;
  padding-bottom: 100px;
  width: 90vw;
  color: var(--blue-dark);
  border-radius: 5px;
  text-align: center;
  z-index: -1;
}
#main-title {
  max-width: 700px;
  font-size: 8rem;
  line-height: 1.2;
  word-wrap: break-word;
}
@media only screen and (max-width: 768px) {
  .title-message-container {
    padding: 80px 10px;
    width: 95vw;
  }
  
  #main-title {
    font-size: 4rem;
  }
}

.raindrop-container {
  max-width: 1000px;
  width: 90vw;
  padding-top: 30px;
  padding-bottom: 30px;
  margin: 1rem auto;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  grid-gap: 1rem;
}

.key-message-item {
  display: grid;
  grid-template-columns: 1fr 4fr;
  grid-gap: 0rem;
  position: relative;
  width: 90%;
  margin: 0px;
  padding: 10px;
  background-color: var(--cream-background);
  overflow: visible;
}


.key-message-item-text {
  color: var(--blue-dark);
  width: 100%;
  font-size: 3rem;
  text-align: left;
}

.raindrop {
  float: left;
  width: 60px;
  height: 60px;
  border-radius: 0 50% 50% 50%;
  border: 0px;
  transform: rotate(45deg);
  margin-right: 20px;
  margin-bottom: 10px;
  margin-top: 35px;
  background-color: var(--blue-light);
  border: 0 solid;
  box-shadow: inset 0 0 35px var(--teal-dark);
  outline: 1px solid;
  outline-color: rgba(255, 255, 255, .5);
  outline-offset: 0px;
  text-shadow: none;
  transition: all 1250ms cubic-bezier(0.19, 1, 0.22, 1);
  shape-outside: ellipse(65% 95% at 50% 25%);
  clip-path: ellipse(65% 95% at 50% 25%);
}


.raindrop:hover {
  cursor: pointer;
  background-color:  var(--teal-dark);
  border: 1px solid;
  box-shadow: inset 0 0 10px var(--teal-dark), 0 0 10px  var(--teal-dark);
  outline-color:  var(--blue-dark);
  outline-offset: 5px;
  text-shadow: 1px 1px 2px var(--blue-dark); 
}


.raindrop-text {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) rotate(-45deg);
  color: var(--cream-background);
  font-size: 40px;
  font-weight: bold;
}

</style>