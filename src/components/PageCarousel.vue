<template>
    <div class="nav-container">
        <!-- Left Arrow -->
        <button v-if="showLeftArrow" class="arrow-button" @click="moveLeft()"><</button>
        <button v-if="!showLeftArrow" class="arrow-button-hidden"><</button>

        <!-- First Button -->
        <router-link to="/">
            <button v-if="showHomeButtonLeft" class="home-button">RETURN TO MAIN</button>
        </router-link>
        <router-link :to="lowRoute">
            <button v-if="!showHomeButtonLeft" class="nav-button">{{ lowNumber }}</button>
        </router-link>

        <!-- Middle Button -->
        <router-link to="/">
            <button v-if="showHomeButtonMiddle" class="home-button">RETURN TO MAIN</button>
        </router-link>
        <router-link :to="middleRoute">
            <button v-if="!showHomeButtonMiddle" class="nav-button">{{ middleNumber }}</button>
        </router-link>
        
        <!-- Right Button -->
        <router-link to="/">
            <button v-if="showHomeButtonRight" class="home-button">RETURN TO MAIN</button>
        </router-link>
        <router-link :to="highRoute">
            <button v-if="!showHomeButtonRight" class="nav-button">{{ highNumber }}</button>
        </router-link>

        <!-- Right Arrow -->
        <button v-if="showRightArrow" class="arrow-button" @click="moveRight()">></button>
        <button v-if="!showRightArrow" class="arrow-button-hidden">></button>
    </div>
</template>

<script>  
// See nav-notes.md for details on logic
import SubPages from '@/components/SubPages.js';
export default {
    data() {
        return {
            SubPages: SubPages.SubPages,
            lowNumber: 0,
            middleNumber: 0,
            highNumber: 0,
            lowRoute: "",
            middleRoute: "",
            highRoute: "",
            currentRouteId: "",
            showHomeButtonLeft: false,
            showHomeButtonMiddle: true,
            showHomeButtonRight: false,
            showLeftArrow: true,
            showRightArrow: true
        };
    },
    mounted() {
        this.setDefaultCarousel();
    },
    methods: {
        setDefaultCarousel() {
            const currentRoute = this.$route.path; // Get current route
            const currentPageIndex = this.SubPages.findIndex(link => link.route === currentRoute); // the index value uses to pull from SubPages.js for the current page
            let lowIndex = currentPageIndex - 1;
            let middleIndex = currentPageIndex;
            let highIndex = currentPageIndex + 1;
            this.currentRouteId = this.SubPages[middleIndex].page;
            if (middleIndex > 0 && middleIndex < 9) { // this is more all the "normal" pages (not page 1 or 10)
            this.lowRoute = this.SubPages[lowIndex].route; 
            this.middleRoute = this.SubPages[middleIndex].route;
            this.highRoute = this.SubPages[highIndex].route;
            this.lowNumber = this.SubPages[lowIndex].page;
            this.middleNumber = this.SubPages[middleIndex].page;
            this.highNumber = this.SubPages[highIndex].page;
            if (this.highNumber === 10) { // we don't want the right arrow to show in this case since there is nothing right of page 10
                this.showRightArrow = false
            }
            if (this.lowNumber === 1) { // we don't want the left arrow to show in this case since there is nothing left of page 1
                this.showLeftArrow = false
            }
            }
            if (middleIndex === 0) { // Index 0 is page 1 -- if adding or removing pages, change this to the first index
                this.showHomeButtonLeft = true; // we want the Return to Main (home) button to be on the left instead of the middle since there's nothing left of page 1
                this.showLeftArrow = false
                this.showHomeButtonMiddle = false;
                this.lowNumber = this.currentRouteId;
                this.middleNumber = this.currentRouteId + 1;
                this.highNumber = this.currentRouteId + 2;
                this.lowRoute = this.SubPages[middleIndex].route;
                this.middleRoute = this.SubPages[highIndex].route;
                this.highRoute = this.SubPages[highIndex +1].route;
            }
            if (middleIndex === 9) { // Index 9 is page 10 -- if adding or removing pages, change this to the final index
                this.showHomeButtonMiddle = false; // we want the Return to Main (home) button to be on the right instead of the middle since there's nothing right of page 10
                this.showHomeButtonRight = true;
                this.showRightArrow = false;
                this.highNumber = this.currentRouteId;
                this.middleNumber = this.currentRouteId - 1;
                this.lowNumber = this.currentRouteId - 2;
                this.lowRoute = this.SubPages[lowIndex - 1].route;
                this.middleRoute = this.SubPages[lowIndex].route;
                this.highRoute = this.SubPages[middleIndex].route;
            }
        },
        moveLeft() {
            if (this.lowNumber > 1) {
                // Here, we're basically subtracting a number from each number shown, assigning the correct index, and getting the route from SubPages.js
                this.lowNumber--;
                this.middleNumber--;
                this.highNumber--;
                let lowIndex = this.lowNumber - 1; // these are just because the index value is always one less than the page number (0-indexed)
                let middleIndex = this.middleNumber - 1;
                let highIndex = this.highNumber - 1;
                this.lowRoute = this.SubPages[lowIndex].route;
                this.middleRoute = this.SubPages[middleIndex].route;
                this.highRoute = this.SubPages[highIndex].route;
            }

            // where to put the home button
            if (this.lowNumber === this.currentRouteId) {
                this.showHomeButtonLeft = true;
                
            } else {
                this.showHomeButtonLeft = false;
            }

            if (this.middleNumber === this.currentRouteId) {
                this.showHomeButtonMiddle = true;
                
            } else {
                this.showHomeButtonMiddle = false;
            }

            if (this.highNumber === this.currentRouteId) {
                this.showHomeButtonRight = true;
            } else {
                this.showHomeButtonRight = false;
            }

            // boolean for showing the left arrow
            if (this.highNumber === 10) {
                this.showRightArrow = false
            } else {
                this.showRightArrow = true
            }

            if (this.lowNumber === 1) {
                this.showLeftArrow = false
            } else {
                this.showLeftArrow = true
            }
        },
        moveRight() {
            if (this.highNumber < 10) {
                // Here, we're basically adding a number to each number shown, assigning the correct index, and getting the route from SubPages.js
                this.lowNumber++;
                this.middleNumber++;
                this.highNumber++;
                let lowIndex = this.lowNumber - 1; // these are just because the index value is always one less than the page number (0-indexed)
                let middleIndex = this.middleNumber - 1;
                let highIndex = this.highNumber - 1;
                this.lowRoute = this.SubPages[lowIndex].route;
                this.middleRoute = this.SubPages[middleIndex].route;
                this.highRoute = this.SubPages[highIndex].route;
            }

            //where to put the home button
            if (this.lowNumber === this.currentRouteId) {
                this.showHomeButtonLeft = true;
            } else {
                this.showHomeButtonLeft = false;
            }

            if (this.middleNumber === this.currentRouteId) {
                this.showHomeButtonMiddle = true;
                
            } else {
                this.showHomeButtonMiddle = false;
            }

            if (this.highNumber === this.currentRouteId) {
                this.showHomeButtonRight = true;
                
            } else {
                this.showHomeButtonRight = false;
            }

            // boolean for the arrows
            if (this.highNumber === 10) {
                this.showRightArrow = false
            } else {
                this.showRightArrow = true
            }

            if (this.lowNumber === 1) {
                this.showLeftArrow = false
            } else {
                this.showLeftArrow = true
            }
        }
    }
};
</script>

<style scoped>
.nav-container {
    display: flex;
    align-items: center;
    justify-content:center;
    height: 250px;
    position: sticky;
    bottom: 0;
    /* background-color: #edeadf; */
}

.nav-button {
    height: 50px;
    width: 50px;
    /* background-color: #5e7789; */
    border-width: 0px;
    border-radius: 50%;
    color: #edeadf;
    font-size: 40px;
    text-align: center;
    line-height: 0;
    padding-top: -10px;
    margin: 0 20px 0 20px;
    border: 0px;
    background-color: rgb(159, 202, 203);
    border: 0 solid;
    box-shadow: inset 0 0 20px  #427388;
    outline: 1px solid;
    outline-color: rgba(255, 255, 255, .5);
    outline-offset: 0px;
    text-shadow: none;
}

.nav-button:hover {
    cursor: pointer;
  background-color:  #427388;
  border: 1px solid;
  text-shadow: 1px 1px 2px #427388; 
}

.home-button {
    background-color: #edeadf;
    height: 50px;
    width: 100px;
    color: #5e7789;
    letter-spacing: 1px;
    font-size: 20px;
    border-width: 0px;
    font-weight: bold;
}

.home-button:hover {
    color: #00264c;
    cursor: pointer;
}

.arrow-button {
    height: 50px;
    width: 50px;
    background-color: #edeadf;
    border-width: 0px;
    color: #5e7789;
    font-size: 50px;
    display: flex;
    justify-content: center;
    align-items: center;
    font-weight: bold;
    font-family: 'Courier New', Courier, monospace
}
.arrow-button-hidden {
    height: 50px;
    width: 50px;
    background-color: #edeadf;
    border-width: 0px;
    color: #edeadf;
    font-size: 50px;
    display: flex;
    justify-content: center;
    align-items: center;
    font-weight: bold;
    font-family: 'Courier New', Courier, monospace
}

.arrow-button:hover {
    color: #00264c;
    cursor: pointer;
}


@media screen and (max-width: 790px) {
    .nav-container {
        height: 300px;
    }
}  
@media screen and (max-width: 490px) {
    .nav-container {
        height: 350px;
    }
}  

@media screen and (max-width: 418px) {
    .nav-container {
        height: 370px;
    }
} 
</style>