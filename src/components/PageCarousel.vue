<template>
    <div class="nav-container">
        <button class="arrow-button" @click="moveLeft()"><</button>
        <router-link :to="lowRoute">
            <button class="nav-button">{{ lowNumber }}</button>
        </router-link>
        <router-link to="/">
            <button class="home-button">RETURN TO MAIN</button>
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
            lowNumber: 4,
            highNumber: 6,
            lowRoute: "/page4",
            highRoute: "/page6"
        };
    },
    mounted() {
        this.setDefaultCarousel();
    },
    methods: {
        setDefaultCarousel() {
            this.lowNumber = 4;
            this.highNumber = 6;
            let lowIndex = this.lowNumber - 1;
            let highIndex = this.highNumber - 1;
            this.lowRoute = this.pageLinks[lowIndex].route;
            this.highRoute = this.pageLinks[highIndex].route;
            console.log(this.lowRoute, this.highRoute)
        },
        moveLeft() {
            if (this.lowNumber > 1) {
                this.lowNumber--;
                this.highNumber--;
                let lowIndex = this.lowNumber - 1;
                let highIndex = this.highNumber - 1;
                this.lowRoute = this.pageLinks[lowIndex].route;
                this.highRoute = this.pageLinks[highIndex].route;
            }
        },
        moveRight() {
            if (this.highNumber < 10) {
                this.lowNumber++;
                this.highNumber++;
                let lowIndex = this.lowNumber - 1;
                let highIndex = this.highNumber - 1;
                this.lowRoute = this.pageLinks[lowIndex].route;
                this.highRoute = this.pageLinks[highIndex].route;
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
    /* display: flex;
    justify-content: center;
    align-items: center; */
    padding-top: -10px;
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
    margin: 0 20px 0 20px;
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
    margin: 0 20px 0 20px;
    font-weight: bold;
    font-family: 'Courier New', Courier, monospace
}

.arrow-button:hover {
    color: #9FCACB;
    cursor: pointer;
}
</style>