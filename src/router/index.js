import { createRouter, createWebHistory } from 'vue-router'
import VisualizationView from '../views/VisualizationView.vue'
import WaterUseRouter from '../views/WaterUseRouter.vue'
import WaterSupplyRouter from '../views/WaterSupplyRouter.vue'
import RegionalPatternsRouter from '../views/RegionalPatternsRouter.vue'


const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'VisualizationContent',
      component: VisualizationView
    },
    {
      path: '/index.html',
      name: 'Index',
      component: VisualizationView
    },
    {
      path: '/water-use',
      name: 'Water Use',
      component: WaterUseRouter
    },
    {
      path: '/water-supply',
      name: 'Water Supply',
      component: WaterSupplyRouter
    },
    {
      path: '/regional-patterns',
      name: 'Regional Patterns',
      component: RegionalPatternsRouter
    }
  ]
})

export default router
