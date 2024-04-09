<template>
    <section class="main-container">
        <div class="wavy-container">
            <div class="key-message-container">
                <p>The source of public supply water use varies from west to east across the country.</p>
                <h2>Key Message #5</h2>
            </div>
        </div>
        <div class="viz-container">
        <AggReg class="agg-reg-svg"></AggReg>
        <h3 class="dumbbell-header">Public Supply Sourced From:</h3>
        <div class="axis-labels">
            <h3 class="groundwater">Groundwater</h3>
            <h3 class="surface-water"> Surface Water</h3>
        </div>

        <img
            id="dumbbells"
            :src="imgSrc"
            alt=""
        >    
        </div>
        <PageCarousel></PageCarousel>
    </section>
</template>

<script>
import * as d3Base from 'd3';
import AggReg from "@/assets/svgs/AggReg.svg";
import PageCarousel from '../components/PageCarousel.vue';
export default {
    components: {
        AggReg,
        PageCarousel
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
            d3Base.select('.agg-reg-svg').selectAll('.AggReg_nam_nospace') //Modified the whole SVG
                .style("fill", "#d1cdc0")
                .style("stroke", "#edeadf")
                .style("stroke-width", "0.5%")
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
                .style("fill", "#d1cdc0"); 

            //Updates dumbbell chart back to full CONUS
            import(`@/assets/images/ws_ps_dumbbell_centered_CONUS.png`).then(imgSrc => {
                this.imgSrc = imgSrc.default; 
            }); 
        }
    }
};
</script>

<style scoped>
.agg-reg-svg {
    width: 20%;
    height: auto;
    margin-right: 20px;
}
.axis-labels {
    transform: rotate(-90deg);
    width: 35px;
    white-space: nowrap;
    margin-bottom: -270px;
    margin-right: -15px;
}

.dumbbell-header {
    transform: rotate(-90deg);
    width: 35px;
    white-space: nowrap;
    margin-bottom: -260px;
    color: #2d2b2a;
    font-size: 1.2em;
}
.groundwater {
    display: inline;
    margin-right: 15px;
    color: #e9830d;
    font-size: 1.2em;
}
.surface-water {
    display: inline;
    margin-left: 15px;
    color: #2b5d69;
    font-size: 1.2em;
}

img {
    width: 35%
}

</style>