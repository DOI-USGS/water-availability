<template>
    <div class="nav-container">
        <button v-if="showLeftArrow" class="arrow-button" @click="moveLeft()"><</button>
        <router-link to="/">
            <button v-if="showHomeButtonLeft" class="home-button">RETURN TO MAIN</button>
        </router-link>
        <router-link :to="lowRoute">
            <button v-if="!showHomeButtonLeft" class="nav-button">{{ lowNumber }}</button>
        </router-link>
        <router-link to="/">
            <button v-if="showHomeButtonMiddle" class="home-button">RETURN TO MAIN</button>
        </router-link>
        <router-link :to="middleRoute">
            <button v-if="!showHomeButtonMiddle" class="nav-button">{{ middleNumber }}</button>
        </router-link>
        <router-link to="/">
            <button v-if="showHomeButtonRight" class="home-button">RETURN TO MAIN</button>
        </router-link>
        <router-link :to="highRoute">
            <button v-if="!showHomeButtonRight" class="nav-button">{{ highNumber }}</button>
        </router-link>
        <button v-if="showRightArrow" class="arrow-button" @click="moveRight()">></button>
    </div>
</template>

<script>  
import pageLinks from '@/components/pagelinks.js';
export default {
    data() {
        return {
            pageLinks: pageLinks.pageLinks,
            lowNumber: 0,
            middleNumber: 0,
            highNumber: 0,
            lowRoute: "",
            middleRoute: "",
            highRoute: "",
            defaultId: "",
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
            const currentPageIndex = this.pageLinks.findIndex(link => link.route === currentRoute);
            let lowIndex = currentPageIndex - 1;
            let middleIndex = currentPageIndex;
            let highIndex = currentPageIndex + 1;
            console.log(middleIndex)
            this.defaultId = this.pageLinks[middleIndex].id;
            if (middleIndex > 0 && middleIndex < 9) {
            this.lowRoute = this.pageLinks[lowIndex].route; //need to handle page 1 and page 10 since they will be the lowest and the highest
            this.middleRoute = this.pageLinks[middleIndex].route;
            this.highRoute = this.pageLinks[highIndex].route;
            this.lowNumber = this.pageLinks[lowIndex].id;
            this.middleNumber = this.pageLinks[middleIndex].id;
            this.highNumber = this.pageLinks[highIndex].id;
            if (this.highNumber === 10) {
                this.showRightArrow = false
            }
            if (this.lowNumber === 1) {
                this.showLeftArrow = false
            }
            }
            if (middleIndex === 0) {
                this.showHomeButtonLeft = true;
                this.showLeftArrow = false
                this.showHomeButtonMiddle = false;
                this.lowNumber = this.defaultId;
                this.middleNumber = this.defaultId + 1;
                this.highNumber = this.defaultId + 2;
                this.lowRoute = this.pageLinks[middleIndex].route;
                this.middleRoute = this.pageLinks[highIndex].route;
                this.highRoute = this.pageLinks[highIndex +1].route;
            }
            if (middleIndex === 9) {
                this.showHomeButtonMiddle = false;
                this.showHomeButtonRight = true;
                this.showRightArrow = false;
                this.highNumber = this.defaultId;
                this.middleNumber = this.defaultId - 1;
                this.lowNumber = this.defaultId - 2;
                this.lowRoute = this.pageLinks[lowIndex - 1].route;
                this.middleRoute = this.pageLinks[lowIndex].route;
                this.highRoute = this.pageLinks[middleIndex].route;
            }
        },
        moveLeft() {
            if (this.lowNumber > 1) {
                this.lowNumber--;
                this.middleNumber--;
                this.highNumber--;
                let lowIndex = this.lowNumber - 1;
                let middleIndex = this.middleNumber - 1;
                let highIndex = this.highNumber - 1;
                this.lowRoute = this.pageLinks[lowIndex].route;
                this.middleRoute = this.pageLinks[middleIndex].route;
                this.highRoute = this.pageLinks[highIndex].route;
            }
            if (this.lowNumber === this.defaultId) {
                this.showHomeButtonLeft = true;
                
            } else {
                this.showHomeButtonLeft = false;
            }
            if (this.middleNumber === this.defaultId) {
                this.showHomeButtonMiddle = true;
                
            } else {
                this.showHomeButtonMiddle = false;
            }
            if (this.highNumber === this.defaultId) {
                console.log('here')
                this.showHomeButtonRight = true;
                
            } else {
                this.showHomeButtonRight = false;
            }
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
                this.lowNumber++;
                this.middleNumber++;
                this.highNumber++;
                let lowIndex = this.lowNumber - 1;
                let middleIndex = this.middleNumber - 1;
                let highIndex = this.highNumber - 1;
                this.lowRoute = this.pageLinks[lowIndex].route;
                this.middleRoute = this.pageLinks[middleIndex].route;
                this.highRoute = this.pageLinks[highIndex].route;
            }
            if (this.lowNumber === this.defaultId) {
                this.showHomeButtonLeft = true;
                
            } else {
                this.showHomeButtonLeft = false;
            }
            if (this.middleNumber === this.defaultId) {
                this.showHomeButtonMiddle = true;
                
            } else {
                this.showHomeButtonMiddle = false;
            }
            if (this.highNumber === this.defaultId) {
                this.showHomeButtonRight = true;
                
            } else {
                this.showHomeButtonRight = false;
            }
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
    justify-content: center;
    height: 10vh;
}

.nav-button {
    height: 50px;
    width: 50px;
    background-color: #9FCACB;
    border-width: 0px;
    border-radius: 50%;
    color: #edeadf;
    font-size: 40px;
    text-align: center;
    line-height: 0;
    padding-top: -10px;
    margin: 0 20px 0 20px;

}

.nav-button:hover {
    background-color: #5e7789;
    cursor: pointer;
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
    color: #9FCACB;
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

.arrow-button:hover {
    color: #9FCACB;
    cursor: pointer;
}
</style>