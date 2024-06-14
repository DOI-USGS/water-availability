<template>
  <section>
    <div class="wavy-container">
      <div class="key-message-container">
        <h1>2024 National Integrated Water Availability Assessments</h1>
        <h2>Key Takeaways</h2>
      </div>
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

.raindrop-container {
  min-height: 1000px;
}

.key-message-item {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 15px;
}

.key-message-item-text {
  margin-left: 20px;
  color: ;
  width: 70%;
  font-size: 2.5rem;
}

.raindrop {
  width: 50px;
  height: 50px;
  border-radius: 0 50% 50% 50%;
  border: 0px;
  transform: rotate(45deg);
  margin-top: 20px;
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

@media screen and (max-width: 790px) {
    .raindrop-container {
        height: 940px;
    }
}  

@media screen and (max-width: 452px) {
    .raindrop-container {
        height: 1020px;
    }
}  

@media screen and (max-width: 400px) {
    .raindrop-container {
        height: 1060px;
    }
}  

</style>