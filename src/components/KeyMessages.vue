<template>
    <div class="wavy-container">
        <div class="key-message-container">
            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor</p>
            <h2>Key Message #1</h2>
        </div>
    </div>

</template>

<script>
import KeyMessages from '@/components/KeyMessages.js';

// export default {
//     data() {
//         return {
//             KeyMessages: keyMessages.KeyMessage
//         };
//     },
//     mounted() {
//         this.setDefault();
//     },
//     methods: {
//         setDefault() {
//             console.log('here', KeyMessages)
//         }
//     }
// }

</script>

<style lang="scss" scoped>

/* text box within the wavy container which houses key messages */
.key-message-container {
    height: 15vh;
    width: 45vh;
    background-color: #3899B1;
    color: #edeadf;
    padding: 15px;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    border-radius: 5px;
}
</style>