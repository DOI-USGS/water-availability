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
          <li><a href="https://water.usgs.gov/nwaa-data/" target="_blank">Access the Data</a></li>
          <li><router-link to="/credits"> Website Credits</router-link></li>
        </ul>
    </div>
  <section>    
    <div class="glossary-container">
        <div id="text-container">
            <h1>Key Definitions</h1>
            <div class="key-term" v-for="terms, index in termArray" :key="index">
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
    <div class="glossary-references-container">
      <h3>References</h3>
          <div  v-for="reference in theseReferences" :key="reference.refID" >
            <p>
              <ul>
                <li><span v-html="reference.authors" /> (<span v-html="reference.year" />). 
                <a
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
                </li>
              </ul>
            </p>
          </div>
        </div>
    <div class="home-link-container">
          <a href="index.html" rel="noopener noreferrer" class="home-link">
            <h3> Return Home</h3>
          </a>       
    </div>
    
  </section>
  </section>
</template>

<script setup>
import { ref } from 'vue';
import glossaryTerms from '@/assets/text/glossaryTerms.js';
import references from './../assets/text/references.js';
let menuOpen = ref(false);

  // Sort terms
const termArray = glossaryTerms.key.sort((a, b) => a.term.localeCompare(b.term));

// References logic
// filter to this page's key message
const filteredReferences = glossaryTerms.references;
const theseReferences = references.key.filter((item) => filteredReferences.includes(item.refID)) 
// sort by order listed on page, reflected in list on subpages.js
const sortedReferences = theseReferences.sort((a, b) => filteredReferences.indexOf(a.refID) - filteredReferences.indexOf(b.refID))
sortedReferences.forEach((item, index) => { item.referenceNumber = `${index + 1}`; }); // add numbers

// global objects
// S3 resource sourcing
const s3ProdURL = import.meta.env.VITE_APP_S3_PROD_URL;
const baseURL = s3ProdURL + "images/water-availability/"


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
@media only screen and (max-width: 600px) {
  .glossary-container{
    width: 90vw;
  }
}
.glossary-references-container {
  width: 60vw;
  margin: 0 auto;
  padding: 30px 0 10px 30px;
}
@media only screen and (max-width: 600px) {
  .glossary-references-container{
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

@media only screen and (max-width: 600px) {
  .title-message-container {
    padding: 80px 10px;
    width: 95vw;
  }
  
}

</style>