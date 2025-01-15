<template>
    <!-- HEADING -->

    <div class="methods-container">
      <button class="references-accordion">
        <h4>References</h4><span class="symbol">+</span>
      </button>
      <div class="panel-references">
        <div class="references-container">
          <div v-for="reference in theseReferences" :key="reference.refID" >
            <p>
              <span v-html="reference.referenceNumber"/>.   
              <span v-html="reference.authors" /> (<span v-html="reference.year" />). 
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
            </p>
          </div>
        </div>
      </div>
    <div class="report-link-container" v-if="featureToggles.showReportLinks">
          <a href="https://pubs.usgs.gov/publication/pp1894" target="_blank" rel="noopener noreferrer" class="report-link">
          <h3 class="h3-nospacer"> Read the report</h3>
          </a>        
          <a href="https://www.water.usgs.gov/nwaa-data" target="_blank" rel="noopener noreferrer" class="report-link">
          <h3 class="h3-nospacer"> Access the data</h3>
          </a>
        </div>
    </div>
    <div class="home-link-container">
          <a href="index.html" rel="noopener noreferrer" class="home-link">
            <h3 class="h3-nospacer"> Return Home</h3></a>     
        </div>
</template>
  
<script setup>
import { inject, onMounted } from 'vue';
const featureToggles = inject('featureToggles');

defineProps({
  theseReferences: {
    type: Array,
    required: true
  }
});

// Accordion click handler
onMounted(() => {
  const acc = document.getElementsByClassName("references-accordion");
  for (let i = 0; i < acc.length; i++) {
    acc[i].addEventListener("click", function () {
      // toggle class
      this.classList.toggle("active");
      const referencesPanel = this.nextElementSibling;
      const symbol = this.querySelector('.symbol');
      if (referencesPanel.style.display === "block") {
        referencesPanel.style.display = "none";
        symbol.textContent = "+";
      } else {
        referencesPanel.style.display = "block";
        symbol.textContent = "-";
      }
    });
  }
});


</script>
  
<style scoped lang="scss">
  .journal-name {
    font-style: italic;
  }
  .report {
    font-style: italic;
  }


</style>
  