<template>
    <div class="nav-container">
        <div class="nav-page-button-wrapper">
         <button class="nav-page-button" @click="navigateLeft">&#9664</button>
        <div class="nav-wrapper">
        <div class="nav-carousel" data-target="carousel">
          <!-- cards for each page -->
          <div
            class="nav-card"
            v-for="(message, index) in SubPages.SubPages"
            :key="index"
            data-target="card"
            :class="{ 'active-page': isActivePage(message.route) }"
          >
            <router-link :to="message.route">
              <button class="nav-card-button">
                <span class="nav-card-button-text">{{ message.page }}</span>
              </button>
            </router-link>
          </div>
        </div>
      </div>
        <button class="nav-page-button" data-action="slideRight" @click="navigateRight">&#9654</button>
        </div>
    </div>
  </template>
  

  <script setup>
  import { ref } from 'vue';
  import { useRoute, useRouter } from 'vue-router';  // Import Vue Router to access the active route
  import SubPages from '@/components/SubPages.js';
  
  const route = useRoute(); // access the current route
  const router = useRouter(); // programmatically navigate
  const currentIndex = ref(SubPages.SubPages.findIndex((page) => page.route === route.path));

  // Function to check if a route is the active route
  const isActivePage = (routeName) => {
    return route.path === routeName;
  };
  
// Function to navigate to the previous page
const navigateLeft = () => {
  if (currentIndex.value > 0) {
    currentIndex.value--;
    router.push(SubPages.SubPages[currentIndex.value].route); // Navigate to the previous page
  }
};

// Function to navigate to the next page
const navigateRight = () => {
  if (currentIndex.value < SubPages.SubPages.length - 1) {
    currentIndex.value++;
    router.push(SubPages.SubPages[currentIndex.value].route); // Navigate to the next page
  }
};

</script>
  

<style scoped>

.nav-container {
  position: relative;
  height: 70px; 
  width: 80vw;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: center;
}

.nav-wrapper {
  width: 80%; 
  overflow: hidden;
  margin: 0 auto;
}

.nav-carousel {
  margin: 0;
  padding: 0;
  list-style: none;
  display: flex;
  justify-content: space-between;
  transition: all 0.5s ease;
}

.nav-card {
  flex: 1 0 auto; 
  min-width: calc(100% / 10); 
  display: inline-block;
  text-align: center;
}

.nav-card-button {
    width: 40px;
    height: 40px;
    border-radius: 0 50% 50% 50%;
    border: 0px;
    transform: rotate(45deg);
    margin: 20px auto 0px auto;
    background-color: rgb(159, 202, 203);
    border: 0 solid;
    box-shadow: inset 0 0 20px  #427388;
    outline: 1px solid;
    outline-color: rgba(255, 255, 255, .5);
    outline-offset: 0px;
    text-shadow: none;
    transition: all 1250ms cubic-bezier(0.19, 1, 0.22, 1);
}

.nav-card-button:hover {
  background-color: #427388;
  cursor: pointer;
}

.nav-card-button-text {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%) rotate(-45deg);
    font-size: 20px;
  font-weight: bold;
  color: var(--white-soft);
}

.active-page .nav-card-button {
  background-color: #427388; /* highlight current page */
}

.nav-page-button-wrapper {
  display: flex;
  width: 100%;
  height: 100%;
  justify-content: space-between;
  align-items: center;
}

.nav-page-button {
  height: 50px;
  width: 50px;
  color: #427388;
  background-color: transparent;
  font-size: 40px;
  display: flex;
  justify-content: center;
  align-items: center;
  border: none;
  font-weight: bold;
  opacity: 0.9;
}


.nav-page-button:hover {
  color: var(--blue-text-col);
  cursor: pointer;
  opacity: 1;
}


</style>