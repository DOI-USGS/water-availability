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
        <li><a href="glossary.html" target="_blank">Glossary of Terms</a></li>
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
.wavy-container {
  position: relative;
  z-index: 1; /* Set waves below hamburger */
}
.waves {
  position: relative;
  z-index: 1; /* Ensure waves stay below the menu */
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
  color: var(--cream-background);
  font-size: 80px;
  font-weight: bold;
}

.hamburger-menu {
  width: 35px;
  height: 30px;
  position: absolute;
  top: 20px;
  right: 20px;
  cursor: pointer;
  z-index: 100;
}

.hamburger-menu div {
  width: 100%;
  height: 5px;
  background-color: #333;
  margin: 6px 0;
  transition: 0.4s;
}

.bar1 {
  transform: rotate(-45deg) translate(-9px, 6px);
}

.bar2 {
  opacity: 0;
}

.bar3 {
  transform: rotate(45deg) translate(-8px, -8px);
}

.bar {
  transform: none;
  opacity: 1;
}
.dropdown-menu {
  position: absolute;
  top: 60px; /* Position it just below the hamburger */
  right: 20px; /* Align it to the right-hand side */
  background-color: #fff;
  border: 1px solid #ddd;
  box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.1);
  z-index: 99;
  padding: 10px;
  border-radius: 4px;
}

.dropdown-menu ul {
  list-style-type: none;
  margin: 0;
  padding: 0;
}

.dropdown-menu li {
  padding: 10px;
  border-bottom: 1px solid #ddd;
}

.dropdown-menu li:last-child {
  border-bottom: none;
}

.dropdown-menu a,
.dropdown-menu router-link {
  color: #333;
  text-decoration: none;
  font-size: 16px;
  display: block;
}

.dropdown-menu a:hover,
.dropdown-menu router-link:hover {
  background-color: #f1f1f1;
  color: #000;
}

@media only screen and (max-width: 768px) {
    .raindrop-static{
        width: 40px;
        height: 40px;
    }
    .raindrop-static-text{
        font-size: 30px;
    }
    .hamburger-menu {
    top: 10px;
    right: 10px;
  }
}
</style>