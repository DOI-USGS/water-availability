<template>
    <div class="wavy-container">
        <div class="key-message-container" v-for="(message, index) in filteredMessages" :key="index">
            <h2>Key Message #{{ message.page }}</h2>      
            <p>{{ message.keyMessage }}</p>
  
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

/* text box within the wavy container which houses key messages */
.key-message-container {
    height: 70%;
    width: 40%;
    color: rgb(0, 38, 76);
    padding: 10px;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    border-radius: 5px;
}

@media only screen and (max-width: 768px) {
    .key-message-container {
        height: 70%;
        width: 60%;
        padding: 15px;
        align-items: center;
        font-size: 18px;
    }
}

</style>