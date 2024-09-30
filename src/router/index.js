import { createRouter, createWebHistory } from 'vue-router'
import VisualizationView from '../views/VisualizationView.vue'
import page1 from '../views/keyFinding01Budget.vue'
import page2 from '../views/keyFinding02SUIPopn.vue'
import page3 from '../views/keyFinding03SUISVI.vue'
import page4 from '../views/keyFinding04Drought.vue'
import page5 from '../views/keyFinding05WQSource.vue'
import page6 from '../views/keyFinding06WQThreats.vue'
import page7 from '../views/keyFinding07WaterUse.vue'
import page8 from '../views/keyFinding08WaterUseRegional.vue'
import page9 from '../views/keyFinding09WaterUseConsumption.vue'
import page10 from '../views/keyFinding10FutureWater.vue'


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
      path: '/keyFinding01Budget',
      name: 'Page 1',
      component: page1
    },
    {
      path: '/keyFinding02SUIPopn',
      name: 'Page 2',
      component: page2
    },
    {
      path: '/keyFinding03SUISVI',
      name: 'Page 3',
      component: page3
    },
    {
      path: '/keyFinding04Drought',
      name: 'Page 4',
      component: page4
    },
    {
      path: '/keyFinding05WQSource',
      name: 'Page 5',
      component: page5
    },
    {
      path: '/keyFinding06WQThreats',
      name: 'Page 6',
      component: page6
    },
    {
      path: '/keyFinding07WaterUse',
      name: 'Page 7',
      component: page7
    },
    {
      path: '/keyFinding08WaterUseRegional',
      name: 'Page 8',
      component: page8
    },
    {
      path: '/keyFinding09WaterUseConsumption',
      name: 'Page 9',
      component: page9
    },
    {
      path: '/keyFinding10FutureWater',
      name: 'Page 10',
      component: page10
    }
  ]
})

export default router
