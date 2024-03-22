<template>
    <section>
        EXAMPLE<br>
        <router-link to="/">Home</router-link>
        <div class="container">
        <AggReg class="agg-reg-svg"></AggReg>
        <p1 class="dumbbell-label">Public Supply Sourced From:</p1>
        <p1 class="dumbbell-label">Groundwater &nbsp; &nbsp; Surface water</p1>

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
.agg-reg-svg {
    width: 20%;
    height: auto;
}

.dumbbell-label {
    transform: rotate(-90deg);
    width: 35px;
    white-space: nowrap;
    margin-bottom: -160px;
}


.container {
    display: flex;
    align-items: center;
    justify-content: center;
}

img {
    width: 35%
}

</style>