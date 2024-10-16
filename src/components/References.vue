<template>
    <!-- HEADING -->
    <div class="references-container" id="heading">
        <h2>References</h2>
    </div>
    <div class="references-container" v-for="message in filteredMessages">
        <div v-for="reference in message.references">
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
                <span v-if="reference.doi" v-html="reference.doi"></span>
                <span v-else v-html="reference.link"></span>
            </p>
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

const route = useRoute();

const path = computed(() => route.path)

const filteredMessages = SubPages.SubPages.filter(message => message.route === route.path);

</script>
  
<style scoped lang="scss">
    .journal-name {
      font-style: italic;
    }
    .report {
      font-style: italic;
    }
</style>
  