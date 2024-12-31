<template>
    <!-- HEADING -->

    <div class="methods-container">
      <button class="references-accordion">
        <span>References</span><span class="symbol">+</span>
      </button>
      <div class="panel-references">
        <div class="references-container">
          <div  v-for="reference in theseReferences">
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
          <a href="labs.waterdata.usgs.gov/visualizations" target="_blank" rel="noopener noreferrer" class="report-link">
          <h3> Read the report</h3>
          </a>        <a href="labs.waterdata.usgs.gov/visualizations" target="_blank" rel="noopener noreferrer" class="report-link">
          <h3> Access the data</h3>
          </a>
        </div>
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
      this.classList.toggle("references-active");
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


.references-accordion {
  background-color: var(--cream-background);
  color: var(--soft-black);
  cursor: pointer;
  padding: 5px;
  padding-bottom: 0;
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
  border-bottom: 2px solid var(--teal-dark);
}

.references-accordion::before {
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

.references-accordion:hover::before, .references-accordion.active::before {
  border-color: var(--cream-background);
}

.active, .references-accordion:hover {
  background-color: var(--blue-light); 
  color: black;
}

.panel {
  display: none; 
  overflow: hidden;
  margin-bottom: -15px;
  margin-top: -15px;
}

.panel p {
  margin: 20px 25px 0px 25px;
  font-size: 18px;
}
  
.symbol {
  font-size: 32px;
  font-weight: bold;
}
</style>
  