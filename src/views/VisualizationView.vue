<template>
  <section>
    <div class="wavy-container">
      <div class="key-message-container">
        <p>2024 National Integrated Water Availability Assessments</p>
        <h2>Key Messages</h2>
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
.section-header {
  color: var(--dodger-blue);
}

.raindrop-container {
  height: 900px;
}

.key-message-item {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 10px;
}

.key-message-item-text {
  margin-left: 20px;
  color: #5e7789;
  width: 75%;
}

.raindrop {
  width: 50px;
  height: 50px;
  border-radius: 0 50% 50% 50%;
  border: 0px;
  transform: rotate(45deg);
  margin-top: 20px;
  background-color: #DAD6CA;
}

.raindrop:hover {
  cursor: pointer;
  background-color: #C4C0B4;
}

.raindrop-text {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) rotate(-45deg);
  color: #5e7789;
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