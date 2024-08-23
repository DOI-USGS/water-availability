<template>
<!--     <div class="nav-container">
        <div class="key-card-container">
            <div class="key-card-wrapper" v-for="(message, index) in SubPages.SubPages" :key="index">
                <router-link :to="message.route">
                <button class="key-card-button"><span class="key-card-button-text"> {{ message.page }}</span></button>
                </router-link>
                <div class="key-card-text">
                {{ message.keyMessage }}
                </div>
            </div>
        </div>
    </div> -->
    <section class="nav-section">
        <div class="nav-wrapper">
            <div class="nav-carousel" data-target="carousel">
                <div 
                    class="nav-card" 
                    v-for="(message, index) in SubPages.SubPages" 
                    :key="index"
                    data-target="card">
                        <div class="card-content">
                            <router-link :to="message.route">
                            <button class="key-card-button"><span class="key-card-button-text"> {{ message.page }}</span></button>
                            </router-link>
                            <div class="card-text">
                                {{ message.keyMessage }}
                            </div>
                        </div>
                </div>
            </div>
            <div class="nav-button-wrapper">
                <button data-action="slideLeft"></button>
                <button data-action="slideRight"></button>
            </div>
        </div>
    </section>
</template>

<script setup>
    import { ref, onMounted } from 'vue';
    import SubPages from '@/components/SubPages.js';
    
    onMounted(() => {
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

.navigation-section {
    position: relative;
    height: 450px;
    width: 90vw; 
    display: flex;
    align-items: center;
}

.nav-wrapper {
    height: 200px;
    width: 632px;
    position: relative;
    overflow: hidden;
    margin: 0 auto;
}

.nav-button-wrapper {
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    position: absolute;
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
    background: cyan;
    min-width: 200px;
    height: 200px;
    margin-right: 1rem;
    display: inline-block;
}

.swiper {
    width: 900px;
}

.card {
    position: relative;
    background-color: cyan;
    border-radius: 20px;
    height: 400px;
    margin: 20px 0;
    box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
}

.card before{
    content: "";
    position: absolute;
    height: 40%;
    width: 100%;
    background: blue;
    border-radius: 20px 20px 0 0;
}

.card .card-content{
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 30px;
    position: relative;
    z-index: 100;
}

.card .key-card-button {
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

.card .key-card-button-text {
    position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) rotate(-45deg);
  color: var(--white-soft);
  font-size: 35px;
  font-weight: bold;
}

.card .card-text {
    display: flex;
    flex-direction: column;
    align-items: center;
    font-size: 2rem;
}

.swiper-pagination {
    height: 7px;
    width: 26px;
    border-radius: 25px;
    background: red;
}

.swiper-button-next, .swiper-button-prev {
    opacity: 0.7;
    color: blue;
    transition: all 0.3s ease;
}

.swiper-button-next:hover, .swiper-button-prev:hover {
    opacity: 1;
    color: purple;
}






.nav-container {
    position: relative;
    width: 100%;
    height: 100%;
    z-index: 1;
    display: flex;
    transition-property: transform;
    transition-timing-function: var(--swiper-wrapper-transition-timing-function,initial);
    box-sizing: content-box;
}


.key-card-container {
    position: relative;
    display: flex;
    flex-direction: column;
    min-width: 0;
    height: 300px;
    word-wrap: break-word;
    background-color: cyan;
    background-clip: border-box;
    margin-left: auto;
    margin-right: auto;
    position: relative;
    overflow: hidden;
    list-style: none;
    padding: 0;
    z-index: 1;
    display: block;
}

.key-card-wrapper {
    position: relative;
    width: 100%;
    height: 100%;
    z-index: 1;
    display: flex;
    transition-property: transform;
    transition-timing-function: 0.5s;
    box-sizing: content-box;
}

.key-card-text {
  color: var(--blue-text-col);
  width: 90%;
  font-size: 2rem;
}

.key-card-button {
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

.key-card-button-text{
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) rotate(-45deg);
  color: var(--white-soft);
  font-size: 35px;
  font-weight: bold;
}

.nav-button {
    height: 50px;
    width: 50px;
    /* background-color: #5e7789; */
    border-width: 0px;
    border-radius: 50%;
    color: var(--page-bkg-col);
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
    background-color: var(--page-bkg-col);
    height: 50px;
    width: 100px;
    color: #5e7789;
    letter-spacing: 1px;
    font-size: 20px;
    border-width: 0px;
    font-weight: bold;
}

.home-button:hover {
    color: var(--blue-text-col);
    cursor: pointer;
}

.arrow-button {
    height: 50px;
    width: 50px;
    background-color: var(--page-bkg-col);
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
    background-color: var(--page-bkg-col);
    border-width: 0px;
    color: var(--page-bkg-col);
    font-size: 50px;
    display: flex;
    justify-content: center;
    align-items: center;
    font-weight: bold;
    font-family: 'Courier New', Courier, monospace
}

.arrow-button:hover {
    color: var(--blue-text-col);
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