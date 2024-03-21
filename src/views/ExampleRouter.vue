<template>
    <section>
        EXAMPLE<br>
        <router-link to="/">Home</router-link>
        <div class="container">
        <AggReg></AggReg>
        <img
            id="dumbbells"
            src="@/assets/images/ws_ps_dumbbell_centered_CONUS.png"
            alt=""
        >    
    </div>
    </section>
</template>

<script setup>
import AggReg from "@/assets/svgs/AggReg.svg";
//add in a {{  }} to replace CONUS in png path - follow structure of regionDescriptions in drought-timeline

</script>



<style scoped>
.container {
    display: flex;
    align-items: center;
    justify-content: center;
}

img {
    width: 50%
}

</style>