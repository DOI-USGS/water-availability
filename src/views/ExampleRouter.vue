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

<script>
import * as d3Base from 'd3';
import AggReg from "@/assets/svgs/AggReg.svg";
export default {
    components: {
        AggReg
    },
    mounted() {
        this.addInteractions();
    },
    methods: {
        addInteractions() {
            const self = this;
            const mapSVG = d3Base.select('.agg-reg-svg')
        mapSVG.selectAll('.AggReg_nam_nospace')
            .on("mouseover", (event) => self.mouseoverMap(event))
            .on("mouseout", (event) => self.mouseoutMap(event))
        },
        mouseoverMap(event) {
            const self = this;
            let regionID = event.target.id
            console.log(regionID)

            d3Base.select('.agg-reg-svg').selectAll(`#${regionID}`)
                .style("fill", "#5e7789")

            //d3Base.select(`#${regionID}`).style("fill", "red");
        },
        mouseoutMap(event) {
            let regionID = event.target.id
            console.log('out')
            d3Base.select('.agg-reg-svg').selectAll(`#${regionID}`)
                .style("fill", "");
        }
    }
};

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