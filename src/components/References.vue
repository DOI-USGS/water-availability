<template>
    <!-- HEADING -->
    <div class="references-container" id="heading">
        <h2>References</h2>
    </div>
    <div class="references-container">
        <div  v-for="reference in refArray">
          <div v-if="reference.refID === 'Canedo2013'"> 
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
          <a href="labs.waterdata.usgs.gov/visualizations" target="_blank" rel="noopener noreferrer" class="report-link">
          <h3> Read the report</h3>
          </a>        <a href="labs.waterdata.usgs.gov/visualizations" target="_blank" rel="noopener noreferrer" class="report-link">
          <h3> Access the data</h3>
          </a>
        </div>
  </div>
</template>
  
<script setup>
import { computed } from 'vue';
import { useRoute } from 'vue-router';
import SubPages from './SubPages';
import References from './../assets/text/references.js'

const route = useRoute();

const path = computed(() => route.path)

// filter to this page's key message
const filteredMessages = SubPages.SubPages.filter(message => message.route === route.path);

// extract list of references for this page
const filteredReferences = filteredMessages[0].references;
//console.log(filteredMessages[0].references)
console.log('filteredReferences ' + filteredReferences)

const refArray = References.key
console.log(References.key)
console.log(refArray)

// extract references that match the refID from global list
// PROBLEM: I can't figure out how to get all the matches from the refArray that are listed
//    in the filteredReferences list
const theseReferences = refArray.find(ref => ref.refID === filteredReferences[0])
console.log(theseReferences)

</script>
  
<style scoped lang="scss">
    .journal-name {
      font-style: italic;
    }
    .report {
      font-style: italic;
    }
</style>
  