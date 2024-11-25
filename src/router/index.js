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
import glossary from '../views/glossaryPage.vue'


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
      path: '/01Budget',
      name: 'Page 1',
      component: page1
    },
    {
      path: '/02SUI',
      name: 'Page 2',
      component: page2
    },
    {
      path: '/03SVI',
      name: 'Page 3',
      component: page3
    },
    {
      path: '/04Drought',
      name: 'Page 4',
      component: page4
    },
    {
      path: '/05WQSource',
      name: 'Page 5',
      component: page5
    },
    {
      path: '/06WQThreats',
      name: 'Page 6',
      component: page6
    },
    {
      path: '/07WaterUse',
      name: 'Page 7',
      component: page7
    },
    {
      path: '/08WaterUseRegional',
      name: 'Page 8',
      component: page8
    },
    {
      path: '/09Consumption',
      name: 'Page 9',
      component: page9
    },
    {
      path: '/10Future',
      name: 'Page 10',
      component: page10
    },
    {
      path: '/glossary.html',
      name: 'Glossary',
      component: glossary
    }
  ]
})

export default router
