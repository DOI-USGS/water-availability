<template>
  <section>
    <KeyMessages></KeyMessages>
    <div class="glossary-container">
        <div id="text-container">
            <h1>Key Definitions</h1>
            <div class="key-term" v-for="terms in termArray">
                <div class="key-message-item-text">
                    <h3 class="glossary-term"> {{ terms.term }} </h3>
                    <p class="glossary-def"> {{ terms.definition }}</p>
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
        <div class="report-link-container">
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
  import glossaryTerms from '@/assets/text/glossaryTerms.js';
  import KeyMessages from '../components/KeyMessages.vue';
  console.log(glossaryTerms)

  // Sort references
const termArray = glossaryTerms.key.sort((a, b) => a.term.localeCompare(b.term));
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

</style>