<template>
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
    <div class="hamburger-menu" @click="toggleMenu">
        <div :class="{ 'bar1': menuOpen, 'bar': !menuOpen }"></div>
        <div :class="{ 'bar2': menuOpen, 'bar': !menuOpen }"></div>
        <div :class="{ 'bar3': menuOpen, 'bar': !menuOpen }"></div>
    </div>
    <div class="dropdown-menu" v-if="menuOpen">
        <ul>
            <li><router-link to="/">Home</router-link></li>
            <li><a href="https://www.usgs.gov/iwaas" target="_blank">Read the Report</a></li>
            <li><a href="https://water.usgs.gov/nwaa-data/" target="_blank">Access the Data</a></li>
            <li><router-link to="/glossary"> Glossary of Terms</router-link></li>
            <li><router-link to="/credits"> Website Credits</router-link></li>
        </ul>
    </div>

    <div class="key-message-container" v-for="(message, index) in filteredMessages" :key="index">
        <div class="raindrop-static-container">
            <button class="raindrop-static" aria-hidden="true"><span class="raindrop-static-text"> {{ message.page }}</span></button>    
        </div>
        <div class="page-title-container">
            <h1>{{ message.mainTitle }}</h1>
            <h2 class="h2-nospacer"> {{ message.shortTitle }}</h2>
        </div>   
    </div>
    <div class="content-container" v-for="(message, index) in filteredMessages" :key="index">
        <div class="kf-container">
            <h4 class="subheading"> {{ message.keyMessage }}</h4>
        </div>
    </div>

</template>

<script>
import SubPages from '@/components/SubPages.js';

export default {
    data() {
        return {
            SubPages: SubPages,
            menuOpen: false,
        };
    },
    methods: {
        toggleMenu() {
            this.menuOpen = !this.menuOpen;
        },
    },
    computed: {
    filteredMessages() {
        const currentRoute = this.$route.path; // Get current route
        return this.SubPages.SubPages.filter(message => message.route === currentRoute);
    }
    }
}

</script>

<style lang="scss" scoped>
/* text box within the wavy container that houses key messages */
.key-message-container {
    display: grid;
    width: 80vw;
    margin: 0 auto;
    color: var(--blue-dark);
    padding: 20px 0px 20px 0px;
    grid-template-columns: 140px auto;
    grid-gap: 1rem;
    align-items: center;
}

@media only screen and (max-width: 600px) {
  .key-message-container {
    width: 90vw;
    grid-template-columns: 50px auto;
    grid-gap: 1rem;
  }
}



</style>