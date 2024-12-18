<template>
    <!-- HEADING -->
    <div class="references-container" id="heading">
        <h2>References</h2>
    </div>
    <div class="references-container">
        <div  v-for="reference in theseReferences">
          
            <p>
              <span v-html="reference.referenceNumber"/>.   
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
import { computed, inject, onMounted, ref } from 'vue';
const featureToggles = inject('featureToggles');

defineProps({
  theseReferences: {
    type: Array,
    required: true
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
  