<template>
  <section>
    <div class="wavy-container">
      <div class="key-message-container">
        <h1>2024 National Integrated Water Availability Assessments</h1>
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
  background:
    repeating-conic-gradient( var(--dodger-blue) 0 3%, #DAD6CA 0 11%),
    repeating-conic-gradient(#DAD6CA 0 5%, var(--dodger-blue) 0 7%) 50% / 60% 60%,
    repeating-conic-gradient(#DAD6CA 0 7%, var(--dodger-blue) 0 9%) 50% / 70% 70%,
    repeating-conic-gradient(#DAD6CA 0 11%, var(--dodger-blue) 0 13%) 50% / 80% 80%,
    radial-gradient(var(--dodger-blue) 22%, #DAD6CA 0),
    #9FCACB;
  background-repeat: no-repeat;
  filter: blur(2px) contrast(80);
  box-shadow: 0 0 0 2px #fff;
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