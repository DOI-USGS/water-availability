<template>
  <div class="nav-container">
    <div class="nav-page-button-wrapper">
      <button class="nav-page-button" @click="navigateLeft">&#9664</button>
      <div class="nav-wrapper">
        <div class="nav-carousel" data-target="carousel">
          <!-- Previous card -->
          <div
            class="nav-card"
            v-if="currentIndex > 0"
            :class="{ 'active-page': isActivePage(SubPages.SubPages[currentIndex - 1].route) }"
          >
            <router-link :to="SubPages.SubPages[currentIndex - 1].route">
              <button class="nav-card-button">
                <span class="nav-card-button-text">{{ SubPages.SubPages[currentIndex - 1].page }}</span>
              </button>
            </router-link>
          </div>
          
          <!-- Current card -->
          <div
            class="nav-card"
            :class="{ 'active-page': isActivePage(SubPages.SubPages[currentIndex].route) }"
          >
            <router-link :to="SubPages.SubPages[currentIndex].route">
              <button class="nav-card-button">
                <span class="nav-card-button-text">{{ SubPages.SubPages[currentIndex].page }}</span>
              </button>
            </router-link>
          </div>

          <!-- Next card -->
          <div
            class="nav-card"
            v-if="currentIndex < SubPages.SubPages.length - 1"
            :class="{ 'active-page': isActivePage(SubPages.SubPages[currentIndex + 1].route) }"
          >
            <router-link :to="SubPages.SubPages[currentIndex + 1].route">
              <button class="nav-card-button">
                <span class="nav-card-button-text">{{ SubPages.SubPages[currentIndex + 1].page }}</span>
              </button>
            </router-link>
          </div>
        </div>
      </div>
      <button class="nav-page-button" @click="navigateRight">&#9654</button>
    </div>
  </div>
</template>


  

  <script setup>
  import { ref } from 'vue';
  import { useRoute, useRouter } from 'vue-router';  // access the active route
  import SubPages from '@/components/SubPages.js';
  
  const route = useRoute(); // access the current route
  const router = useRouter(); // programmatically navigate
  const currentIndex = ref(SubPages.SubPages.findIndex((page) => page.route === route.path));

  // check if a route is the active route
  const isActivePage = (routeName) => {
    return route.path === routeName;
  };
  
// navigate to the previous page
const navigateLeft = () => {
  if (currentIndex.value > 0) {
    currentIndex.value--;
  } else {
    currentIndex.value = SubPages.SubPages.length - 1;  // Loop back to the last card if at the beginning
  }
  router.push(SubPages.SubPages[currentIndex.value].route);
};

// navigate to the next page
const navigateRight = () => {
  if (currentIndex.value < SubPages.SubPages.length - 1) {
    currentIndex.value++;
  } else {
    currentIndex.value = 0;  // Loop back to the first card if at the end
  }
  router.push(SubPages.SubPages[currentIndex.value].route);
};

// go home
const returnToHome = () => {
  currentIndex.value = 0;  // set index to 0 for home button
  router.push("/");  // og home bb
};

</script>
  

<style scoped>

.nav-page-button-wrapper {
  display: flex;
  width: 40%;
  height: 100%;
  justify-content: space-between;
  align-items: center;
}
@media only screen and (max-width:490px) {
  .nav-page-button-wrapper {
  width: 100%;
  }
}

.nav-container {
  position: relative;
  height: 70px; 
  width: 80vw;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: center;
}
@media only screen and (max-width:490px) {
  .nav-container {
  height: 160px; 
  } 
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
  min-width: calc(80% / 10); 
  display: inline-block;
  text-align: center;
}

.nav-card-button {
    width: 40px;
    height: 40px;
    border-radius: 0 50% 50% 50%;
    transform: rotate(45deg);
    margin: 10px auto 0px auto;
    background-color: transparent;
    border: 2px solid #427388;
    outline: 1px solid;
    outline-color: rgba(255, 255, 255, .5);
    outline-offset: 0px;
    text-shadow: none;
    transition: all 0ms cubic-bezier(0.19, 1, 0.22, 1);
    color: #427388;
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
  color: #427388;
}

.active-page .nav-card-button {
  background-color: #427388; /* highlight current page */
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

.return-home-button-wrapper {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.return-home-button {
  padding: 10px 20px;
  background-color: #427388;
  color: white;
  border: none;
  font-size: 20px;
  font-weight: bold;
  cursor: pointer;
  border-radius: 5px;
  white-space: nowrap;
}

.return-home-button:hover {
  background-color: var(--blue-text-col);
}

</style>