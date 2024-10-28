<template>
    <!-- HEADING -->
    <div class="methods-container" id="heading">
        <h2>Methodology</h2>
    </div>
    <div class="methods-container">
            <p>
                {{ thisMethod }}
            </p>
    </div>

</template>
  
<script setup>
import { computed } from 'vue';
import { useRoute } from 'vue-router';
import SubPages from './SubPages';
import Methods from './../assets/text/methods.js';

const route = useRoute();

const path = computed(() => route.path)

// filter to this page's key message
const methodArray = Methods.key.filter(message => message.route === route.path);
const thisMethod = methodArray[0].description;



</script>
  
<style scoped lang="scss">

  
</style>
  