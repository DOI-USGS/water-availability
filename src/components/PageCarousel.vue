<template>
    <div class="nav-container">
        <div class="nav-wrapper">
            <div class="nav-carousel" data-target="carousel">
                <div 
                    class="nav-card" 
                    v-for="(message, index) in SubPages.SubPages" 
                    :key="index"
                    data-target="card">
                        <div class="nav-card-content">
                            <router-link :to="message.route">
                            <button class="nav-card-button"><span class="nav-card-button-text"> {{ message.page }}</span></button>
                            </router-link>
                            <div class="nav-card-text">
                                {{ message.keyMessage }}
                            </div>
                        </div>
                </div>
            </div>

        </div>
        <div class="nav-page-button-wrapper">
                <button class="nav-page-button" data-action="slideLeft"><</button>
                <button class="nav-page-button" data-action="slideRight">></button>
        </div>
    </div>
</template>

<script setup>
    import { ref, onMounted } from 'vue';
    import SubPages from '@/components/SubPages.js';
    
    onMounted(() => {
        // https://medium.com/@magyarn/simple-carousel-with-vanilla-js-3dd10a143ff2
        // Select the carousel you'll need to manipulate and the buttons you'll add events to
        const carousel = document.querySelector("[data-target='carousel']");
        const card = carousel.querySelector("[data-target='card']");
        const leftButton = document.querySelector("[data-action='slideLeft']");
        const rightButton = document.querySelector("[data-action='slideRight']");

        // Prepare to limit the direction in which the carousel can slide, 
        // and to control how much the carousel advances by each time.
        // In order to slide the carousel so that only three cards are perfectly visible each time,
        // you need to know the carousel width, and the margin placed on a given card in the carousel
        const carouselWidth = carousel.offsetWidth;
        const cardStyle = card.currentStyle || window.getComputedStyle(card)
        const cardMarginRight = Number(cardStyle.marginRight.match(/\d+/g)[0]);

        // Count the number of total cards you have
        const cardCount = carousel.querySelectorAll("[data-target='card']").length;

        // Define an offset property to dynamically update by clicking the button controls
        // as well as a maxX property so the carousel knows when to stop at the upper limit
        let offset = 0;
        const maxX = -((cardCount / 3) * carouselWidth + 
                    (cardMarginRight * (cardCount / 3)) - 
                    carouselWidth - cardMarginRight);


        // Add the click events
        leftButton.addEventListener("click", function() {
        if (offset !== 0) {
            offset += carouselWidth + cardMarginRight;
            carousel.style.transform = `translateX(${offset}px)`;
            }
        })
        
        rightButton.addEventListener("click", function() {
        if (offset !== maxX) {
            offset -= carouselWidth + cardMarginRight;
            carousel.style.transform = `translateX(${offset}px)`;
        }
        })
    });


    

    
</script>

<style scoped>

.nav-container {
    position: relative;
    height: 250px;
    width: 1000px; 
    margin: 0 auto 0 auto;
    display: flex;
    align-items: top;
}

.nav-wrapper {
    height: 250px;
    width: 750px;
    position: relative;
    overflow: hidden;
    margin: 0 auto;
}
@media screen and (max-width: 790px) {
    .nav-container {
        width: 300px;
    }
    .nav-wrapper {
        width: 250px;
    }
}  

.nav-carousel {
    margin: 0;
    padding: 0;
    list-style: none;
    width: 100%;
    display: flex;
    position: absolute;
    left: 0;
    transition: all 1s ease;
}

.nav-card {
    min-width: 250px;
    height: 200px;
    display: inline-block;
}

.nav-card-content{
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 0 15px;
    position: relative;
    z-index: 0;
}
@media screen and (max-width: 790px) {
    .nav-card-content {
        padding: 0 25px;
    }
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
    cursor: pointer;
    background-color:  #427388;
    border: 1px solid;
    text-shadow: 1px 1px 2px #427388; 
}

.nav-card-button-text {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%) rotate(-45deg);
    color: var(--white-soft);
    font-size: 35px;
    font-weight: bold;
}

.nav-card-text {
    display: flex;
    flex-direction: column;
    align-items: center;
    font-size: 1.8rem;
    color: var(--blue-text-col);
    padding-top: 10px;
}
@media screen and (max-width: 790px) {
    .nav-card-text {
        font-size: 1.4rem;
    }
}


.nav-page-button-wrapper {
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    position: absolute;
}

.nav-page-button {
    height: 50px;
    width: 50px;
    border-width: 0px;
    color: var(--grey-blue);
    background-color: transparent;
    font-size: 50px;
    display: flex;
    justify-content: center;
    align-items: center;
    font-weight: bold;
    font-family: 'Courier New', Courier, monospace;
    opacity: 0.2;
}

.nav-page-button:hover {
    color: var(--blue-text-col);
    cursor: pointer;
    background-color: var(--blue-highlight-col);
    opacity: 0.6;
}

</style>