<template>
    <section>
        EXAMPLE<br>
        <router-link to="/">Home</router-link>
        <div class="container">
        <AggReg class="agg-reg-svg" style="fill: #dad6ca"></AggReg>
        <p1 class="dumbbell-label">Public Supply Sourced From:</p1>
        <p1 class="dumbbell-label">Groundwater &nbsp; &nbsp; Surface water</p1>

        <img
            id="dumbbells"
            :src="imgSrc"
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
    data() {
        return {
            imgSrc: '@/assets/images/ws_ps_dumbbell_centered_CONUS.png'
        };
    },
    mounted() {
        this.setDefaultImgSrc();
        this.addInteractions();
    },
    methods: {
        setDefaultImgSrc() {
            //Sets default dumbbell chart to full CONUS
            import(`@/assets/images/ws_ps_dumbbell_centered_CONUS.png`).then(imgSrc => {
                this.imgSrc = imgSrc.default; 
            }); 
        },
        addInteractions() {
            const self = this;
            const mapSVG = d3Base.select('.agg-reg-svg')
        mapSVG.selectAll('.AggReg_nam_nospace')
            .on("mouseover", (event) => self.mouseoverMap(event))
            .on("mouseout", (event) => self.mouseoutMap(event))
        },
        mouseoverMap(event) {
            let regionID = event.target.id
            //d3Base.select('.agg-reg-svg').selectAll('.AggReg_nam_nospace') //Modified the whole SVG
                //.style("fill", "#dad6ca")

            //Updates color of region
            d3Base.select('.agg-reg-svg').selectAll(`#${regionID}`)
                .style("fill", "#5e7789") //updates color of region that is being hovered on

            let formattedRegionID = regionID.replace(/_/g, ' '); //png titles have spaces not underscores
            
            //Update dumbbells charts to specific region
            import(`@/assets/images/ws_ps_dumbbell_centered_${formattedRegionID}.png`).then(imgSrc => {
                this.imgSrc = imgSrc.default;
            });       
        },
        mouseoutMap(event) {
            let regionID = event.target.id

            //Updates region back to default
            d3Base.select('.agg-reg-svg').selectAll(`#${regionID}`)
                .style("fill", ""); 

            //Updates dumbbell chart back to full CONUS
            import(`@/assets/images/ws_ps_dumbbell_centered_CONUS.png`).then(imgSrc => {
                this.imgSrc = imgSrc.default; 
            }); 
        }
    }
};

</script>



<style scoped>
.agg-reg-svg svg * {
    width: 20%;
    height: auto;
    fill: #dad6ca !important;
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