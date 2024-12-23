<template>
  <section>
    <div class="wavy-container">
      <div class="title-message-container">
        <h2 id="main-title">Water availability in the United States</h2>
        <p class="byline">Powered by the <a class="byline-a" href="https://labs.waterdata.usgs.gov/visualizations" target="_blank">USGS Vizlab</a></p>
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
          <div>
            <router-link 
              :to="message.route"
              :class="{
                disabled: !featureToggles.keyFindingToggles[`keyFinding${index + 1 < 10 ? `0${index + 1}` : index + 1}`]
              }"
              @click.prevent="!featureToggles.keyFindingToggles[`keyFinding${index + 1 < 10 ? `0${index + 1}` : index + 1}`] ? null : undefined"
            >
              <button 
                class="raindrop"
                :disabled="!featureToggles.keyFindingToggles[`keyFinding${index + 1 < 10 ? `0${index + 1}` : index + 1}`]"
              >
                <span class="raindrop-text">{{ message.page }}</span>
              </button>
            </router-link>
          </div>
          <div class="key-message-item-text">
            <h3>{{ message.mainTitle }}</h3>
            <h4>{{ message.shortTitle }}</h4>
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
        <h2>About the National Water Availability Assessment</h2>
        <p>The National Water Availability Assessment Report is the <strong>first nationwide assessment of water availability</strong> that includes the amount of water, quality of water, and use of water for human and ecosystem needs. This assessment uses <strong>state-of-the-art models</strong> to enable a new evaluation of the balance between natural water supply and water demands at fine scales, providing <strong>new insight on areas of the United States with a supply-use imbalance</strong>. In addition, the underlying <strong>modeled water supply and demand data </strong>spanning multiple decades into the past are available in the National Water Availability Assessment Data Companion. <a href="usgs.gov/iwaas" target="_blank">Read more about Water Availability at the USGS</a></p> 
        <div 
          v-if="featureToggles.showReportLinks" 
          class="report-link-container">
          <a href="labs.waterdata.usgs.gov/visualizations" target="_blank" rel="noopener noreferrer" class="report-link">
            <h3> Read the report</h3></a>        
          <a href="labs.waterdata.usgs.gov/visualizations" target="_blank" rel="noopener noreferrer" class="report-link">
            <h3> Access the data</h3>
          </a>
        </div>
      </div>
    </section>
    <!-- router-view to render subpages and pass the toggle as a prop -->
    <router-view :show-carousel="featureToggles.showPageCarousel"></router-view>
  </section>
</template>

<script setup>
  import { reactive, inject } from 'vue';
  import SubPages from '@/components/SubPages.js';


  const featureToggles = inject('featureToggles');

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
  max-width: 60vw;
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
.disabled {
  pointer-events: none;
  opacity: 0.5;
  cursor: not-allowed;
}

.raindrop.disabled {
  background-color: grey;
  box-shadow: none;
  outline: none;
}

.byline {
  font-size: 15px;
}
.byline-a {
  color: var(--blue-dark);
}
.byline-a:visited {
  color: var(--blue-dark);
}


</style>