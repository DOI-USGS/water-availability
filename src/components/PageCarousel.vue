<template>
    <div class="nav-container">
        <button class="arrow-button" @click="moveLeft()"><</button>
        <router-link :to="lowRoute">
            <button class="nav-button">{{ lowNumber }}</button>
        </router-link>
        <router-link to="/">
            <button v-if="showHomeButton" class="home-button">RETURN TO MAIN</button>
        </router-link>
        <router-link :to="middleRoute">
            <button v-if="!showHomeButton" class="nav-button">{{ middleNumber }}</button>
        </router-link>
        <router-link :to="highRoute">
            <button class="nav-button">{{ highNumber }}</button>
        </router-link>
        <button class="arrow-button" @click="moveRight()">></button>
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
            showHomeButton: true
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
            this.lowRoute = this.pageLinks[lowIndex].route;
            this.middleRoute = this.pageLinks[middleIndex].route;
            this.highRoute = this.pageLinks[highIndex].route;
            this.defaultId = this.pageLinks[middleIndex].id;
            this.lowNumber = this.pageLinks[lowIndex].id;
            this.middleNumber = this.pageLinks[middleIndex].id;
            this.highNumber = this.pageLinks[highIndex].id;
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
            if (this.middleNumber === this.defaultId) {
                this.showHomeButton = true;
            } else {
                this.showHomeButton = false;
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
                this.showHomeButton = false;
            }
            if (this.middleNumber === this.defaultId) {
                this.showHomeButton = true;
            } else {
                this.showHomeButton = false;
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
    font-size: 50px;
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