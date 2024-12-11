<template>
  <section class="main-container">    
    <div class="wavy-container">
        <section>
        <div class="waves">
          <div class="wave" id="wave1"></div>
          <div class="wave" id="wave2"></div>
          <div class="wave" id="wave3"></div>
          <div class="wave" id="wave4"></div>
        </div>
      </section>
    </div>
    <div class="hamburger-menu" @click="menuOpen = !menuOpen">
        <div :class="{ 'bar1': menuOpen, 'bar': !menuOpen }"></div>
        <div :class="{ 'bar2': menuOpen, 'bar': !menuOpen }"></div>
        <div :class="{ 'bar3': menuOpen, 'bar': !menuOpen }"></div>
    </div>
    <div class="dropdown-menu" v-if="menuOpen">
        <ul>
        <li><router-link to="/">Home</router-link></li>
        <li><a href="https://labs.waterdata.usgs.gov/visualizations/index.html" target="_blank">Read the Report</a></li>
        <li><a href="https://labs.waterdata.usgs.gov/visualizations/index.html" target="_blank">Access the Data</a></li>
        <li><a href="https://labs.waterdata.usgs.gov/visualizations/index.html" target="_blank">USGS Vizlab</a></li>
        <li><a href="water-availability/#/credits" target="_blank">Website Credits</a></li>
        </ul>
    </div>
  <section>    
    <div class="glossary-container">
        <div id="text-container">
            <h1>Key Definitions</h1>
            <div class="key-term" v-for="terms in termArray">
                <div class="key-message-item-text">
                    <h3 class="glossary-term"> {{ terms.term }} </h3>
                    <p class="glossary-def"> {{ terms.definition }}</p>
                    <div v-if="terms.visualLogic" class="viz-container">
                      <img class="viz-portrait" :src="getIconURL(terms.visual)">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="references-container">
        <h2>References</h2>
      <div  v-for="reference in theseReferences">
          <p>
              <span v-html="reference.authors" /> (<span v-html="reference.year" />). <a
              :href="reference.link"
              target="_blank"
              ><span v-html="reference.title" :class="{ report: reference.report }"/></a>
              <span v-if="reference.data_release">: U.S. Geological Survey data release</span>.
              <span v-if="reference.publication_info"> {{ reference.publication_info }}. </span>
              <span v-if="reference.journal">
              <span v-html="reference.journal_name" class="journal-name"></span>
              <span v-if="reference.journal_issue">, {{ reference.journal_issue }}</span>.
              </span>
              <span v-if="reference.doi">DOI: {{ reference.doi }}</span>
          </p>
      </div>
    </div>
    <div class="report-link-container">
          <a href="index.html" rel="noopener noreferrer" class="report-link">
            <h3> Return Home</h3>
          </a>       
    </div>
  </section>
  </section>
</template>

<script setup>
import { ref } from 'vue';
import glossaryTerms from '@/assets/text/glossaryTerms.js';
import KeyMessages from '../components/KeyMessages.vue';
import References from './../assets/text/references.js';
let menuOpen = ref(false);

  // Sort terms
const termArray = glossaryTerms.key.sort((a, b) => a.term.localeCompare(b.term));

// extract list of references for this page
const filteredReferences = glossaryTerms.references;
console.log(filteredReferences)


const refArray = References.key.sort((a, b) => a.authors.localeCompare(b.authors));

// extract references that match the refID from global list
const theseReferences = refArray.filter((item) => filteredReferences.includes(item.refID));

console.log(theseReferences)

// global objects
const baseURL = "https://labs.waterdata.usgs.gov/visualizations/images/water-availability/"


function getIconURL(suffix) {
    return baseURL + `${suffix}.png`
}

</script>

<style scoped>


/* text box within the wavy container that houses key messages */

.glossary-container {
  width: 60vw;
  margin: 0 auto;
  padding: 10px 0 10px 0;
}
@media only screen and (max-width: 768px) {
  .glossary-container{
    width: 90vw;
  }
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
  text-align: left;
}

.glossary-term {
    padding-left: 1em;
    padding-top: 1em;
}
.glossary-def {
    padding-left: 3em;
    padding-top: 0.5em;
}

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

@media only screen and (max-width: 768px) {
  .title-message-container {
    padding: 80px 10px;
    width: 95vw;
  }
  
}

</style>