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
        <li><a href="https://labs.waterdata.usgs.gov/visualizations/index.html" target="_blank">Read the Report</a></li>
        <li><a href="https://labs.waterdata.usgs.gov/visualizations/index.html" target="_blank">Access the Data</a></li>
        <li><a href="https://labs.waterdata.usgs.gov/visualizations/index.html" target="_blank">USGS Vizlab</a></li>
        <li><a href="water-availability/#/glossary" target="_blank">Glossary of Terms</a></li>
        <li><a href="water-availability/#/credits" target="_blank">Website Credits</a></li>
        </ul>
    </div>

    <div class="key-message-container" v-for="(message, index) in filteredMessages" :key="index">
        <div class="raindrop-static-container">
            <button class="raindrop-static"><span class="raindrop-static-text"> {{ message.page }}</span></button>    
        </div>
        <div class="page-title-container">
            <h1>{{ message.mainTitle }}</h1>
            <h3> {{ message.shortTitle }}</h3>
        </div>   
    </div>
    <div class="content-container" v-for="(message, index) in filteredMessages" :key="index">
        <div class="text-container">
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

@media only screen and (max-width: 768px) {
  .key-message-container {
    width: 90vw;
    grid-template-columns: 50px auto;
    grid-gap: 1rem;
  }
}

.raindrop-static {
  width: 100px;
  height: 100px;
  border-radius: 0 50% 50% 50%;
  border: 0px;
  transform: rotate(45deg);
  margin: 20px auto 0px auto;
  background-color: var(--blue-light);
  border: 0 solid;
  box-shadow: inset 0 0 40px  var(--blue-dark);
  outline: 1px solid;
  outline-color: var(--cream-background);
  outline-offset: 0px;
  text-shadow: none;
  transition: all 1250ms cubic-bezier(0.19, 1, 0.22, 1);
}
.raindrop-static-text {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) rotate(-45deg);
  color: white;
  font-size: 80px;
  font-weight: bold;
}

</style>