<template>
  <section>    
    <div class="authors-container">
        <div id="text-container">
            <h1>Website Credits</h1>
            <div class="key-term" v-for="terms in termArray">
                <div class="key-message-item-text">
                    <h3 class="glossary-term"> {{ terms.term }} </h3>
                    <p class="glossary-def"> {{ terms.definition }}</p>
                    <div v-if="terms.visualLogic" class="viz-container">
                      <img class="viz-portrait" src="../assets/images/manual/glossary_huc.png">
                    </div>
                </div>
            </div>
        </div>
    <div
        id="author-container"
        class="text-content"
      >
      <p>
          This website was developed by the <a href='https://labs.waterdata.usgs.gov/visualizations/' target='_blank'>USGS Vizlab</a>
          <span id="primary-author-statment">
            and led by 
            <span
              v-for="(author, index) in authorLeads" 
              :id="`initial-${author.initials}`"
              :key="`${author.initials}-attribution`"
              :class="'author first'"
            >
              <a
                :href="author.profile_link"
                target="_blank"
                v-text="author.fullName"
              />
              <span v-if="index != Object.keys(authorLeads).length - 1 && Object.keys(authorLeads).length > 2">, </span>
              <span v-if="index == Object.keys(authorLeads).length - 2"> and </span>
            </span>.
          </span>
        </p>
      <h2>Meet the Vizlab Team</h2>
        <p>
            The USGS Vizlab is a data visualization team within the USGS <a href='https://www.usgs.gov/mission-areas/water-resources' target='_blank'>Water Resources Mission Area</a>. View the Vizlab <a href='https://labs.waterdata.usgs.gov/visualizations/' target='_blank'>portfolio</a>.
          <span id="primary-author-statment">
            Vizlab team members include
            <span
              v-for="(author, index) in authorsVizlab" 
              :id="`initial-${author.initials}`"
              :key="`${author.initials}-attribution`"
              :class="'author first'"
            >
              <a
                :href="author.profile_link"
                target="_blank"
                v-text="author.fullName"
              />
              <span v-if="index != Object.keys(authorsVizlab).length - 1 && Object.keys(authorsVizlab).length > 2">, </span>
              <span v-if="index == Object.keys(authorsVizlab).length - 2"> and </span>
            </span>.
          </span>
        </p>
        <h2>Meet the National IWAAs Authors</h2>
        <p>
            The chapter leads for the National Integrated Water Availability Assessment Report includes
          <span id="primary-author-statment">
            <span
              v-for="(author, index) in authorSMEs" 
              :id="`initial-${author.initials}`"
              :key="`${author.initials}-attribution`"
              :class="'author first'"
            >
              <a
                :href="author.profile_link"
                target="_blank"
                v-text="author.fullName"
              />
              <span v-if="index != Object.keys(authorSMEs).length - 1 && Object.keys(authorSMEs).length > 2">, </span>
              <span v-if="index == Object.keys(authorSMEs).length - 2"> and </span>
            </span>.
          </span>
        </p>
      </div>
    </div>
    <div class="report-link-container">
          <a href="index.html" rel="noopener noreferrer" class="report-link">
            <h3> Return Home</h3>
          </a>       
    </div>
  </section>
</template>

<script setup>
  import authorList from '@/assets/text/authors.js';

  const authorLeads = authorList.leads;

  const authorsVizlabUnsort = authorLeads.concat(authorList.devs);
  console.log(authorsVizlabUnsort[0].fullOrder)

    const authorsVizlab = authorsVizlabUnsort.sort((a, b) => a.fullOrder - b.fullOrder);

  const authorSMEs = authorList.scientists;

</script>

<style scoped>


/* text box within the wavy container that houses key messages */

.authors-container {
  width: 60vw;
  margin: 0 auto;
  padding: 10px 0 10px 0;
}
@media only screen and (max-width: 768px) {
  .authors-container{
    width: 90vw;
  }
}


#authors {
    font-style: italic;
    font-weight: 300;
  }



.key-message-item-text {
  color: var(--blue-dark);
  width: 100%;
  text-align: left;
}

</style>