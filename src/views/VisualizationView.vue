<template>
  <section>
    <div class="wavy-container">
      <div class="title-message-container">
        <h1>The Status of Water Availability in the United States</h1>
        <h2>Key Findings</h2>
      </div>
      <section>
        <div class="waves">
          <div class="wave" id="wave1"></div>
          <div class="wave" id="wave2"></div>
          <div class="wave" id="wave3"></div>
          <div class="wave" id="wave4"></div>
        </div>
      </section>
    </div>
    <div class="raindrop-container">
      <div class="key-message-item" v-for="(message, index) in SubPages.SubPages" :key="index">
        <router-link :to="message.route">
          <button class="raindrop"><span class="raindrop-text"> {{ message.page }}</span></button>
        </router-link><br>
        <div class="key-message-item-text">
          {{ message.keyMessage }}
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
  import SubPages from '@/components/SubPages.js';
</script>

<style scoped>
/*.section-header {
  color: var(--dodger-blue);
}*/

/* text box within the wavy container that houses key messages */
.title-message-container {
  height: 200px;
  width: 80vw;
  color: var(--blue-text-col);
  padding: 20px 0px 20px 0px;
  align-items: center;
  justify-content: center;
  border-radius: 5px;
}

@media only screen and (max-width: 768px) {
  .title-message-container {
      height: 200px;
      width: 90vw;
      padding: 5px;
      align-items: center;
  }
}

.raindrop-container {
  width: 80vw;
  margin: 0 auto;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  grid-gap: 1rem;
}

.key-message-item {
  display: grid;
  align-items:start;
  justify-items: center;
  grid-template-rows: 70px max-content;
}

.key-message-item-text {
  color: var(--blue-text-col);
  width: 90%;
  font-size: 2rem;
}

.raindrop {
  width: 60px;
  height: 60px;
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

.raindrop:hover {
  cursor: pointer;
  background-color:  #427388;
  border: 1px solid;
  box-shadow: inset 0 0 10px  #427388, 0 0 10px  #427388;
  outline-color:  #427388;
  outline-offset: 5px;
  text-shadow: 1px 1px 2px #427388; 
}

.raindrop-text {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) rotate(-45deg);
  color: var(--white-soft);
  font-size: 40px;
  font-weight: bold;
}

</style>