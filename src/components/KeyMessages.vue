<template>
    <div class="wavy-container">
        <div class="key-message-container" v-for="(message, index) in filteredMessages" :key="index">
            <h4>Key Message #{{ message.page }}</h4>      
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

</style>