<template>
    <div class="wavy-container">
        <section>
        <div class="waves">
          <div class="wave" id="wave1"></div>
          <div class="wave" id="wave2"></div>
          <div class="wave" id="wave3"></div>
          <div class="wave" id="wave4"></div>
        </div>
      </section>
    </div>
    <div class="key-message-container" v-for="(message, index) in filteredMessages" :key="index">
        <div class="raindrop-static-container">
            <button class="raindrop-static"><span class="raindrop-static-text"> {{ message.page }}</span></button>    
        </div>
        <div class="page-title-container">
            <h3>{{ message.keyMessage }}</h3>
        </div>   
    </div>

</template>

<script>
import SubPages from '@/components/SubPages.js';

export default {
    data() {
        return {
            SubPages: SubPages
        };
    },
    computed: {
    filteredMessages() {
        const currentRoute = this.$route.path; // Get current route
        return this.SubPages.SubPages.filter(message => message.route === currentRoute);
    }
    }
}

</script>

<style lang="scss" scoped>
/* text box within the wavy container that houses key messages */
.key-message-container {
    display: grid;
    width: 80vw;
    margin: 0 auto;
    color: var(--blue-text-col);
    padding: 20px 0px 20px 0px;
    grid-template-columns: 140px auto;
    grid-gap: 1rem;
}

@media only screen and (max-width: 768px) {
  .key-message-container {
    width: 90vw;
    align-items: center;
    grid-template-columns: 50px auto;
    grid-gap: 1rem;
  }
}

.raindrop-static {
  width: 100px;
  height: 100px;
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

.raindrop-static-text {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) rotate(-45deg);
  color: var(--page-bkg-col);
  font-size: 80px;
  font-weight: bold;
}
@media only screen and (max-width: 768px) {
    .raindrop-static{
        width: 40px;
        height: 40px;
    }
    .raindrop-static-text{
        font-size: 30px;
    }
}
</style>