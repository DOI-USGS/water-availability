import { createRouter, createWebHashHistory } from 'vue-router'
import VisualizationView from '../views/VisualizationView.vue'
import page1 from '../views/keyFinding01Budget.vue'
import page2 from '../views/keyFinding02SUIPopn.vue'
import page3 from '../views/keyFinding03SUISVI.vue'
import page4 from '../views/keyFinding04Drought.vue'
import page5 from '../views/keyFinding05WQSource.vue'
import page6 from '../views/keyFinding06WQThreats.vue'
import page7 from '../views/keyFinding07WaterUse.vue'
import page8 from '../views/keyFinding08WaterUseRegional.vue'
import glossary from '../views/glossaryPage.vue'
import credits from '../views/creditsPage.vue'


const router = createRouter({
  history: createWebHashHistory(import.meta.env.BASE_URL),
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
      path: '/01-water-limitation',
      name: 'Page 1',
      component: page1
    },
    {
      path: '/02-water-availability',
      name: 'Page 2',
      component: page2
    },
    {
      path: '/03-vulnerability',
      name: 'Page 3',
      component: page3
    },
    {
      path: '/04-water-supply',
      name: 'Page 4',
      component: page4
    },
    {
      path: '/05-nutrients',
      name: 'Page 5',
      component: page5
    },
    {
      path: '/06-water-quality',
      name: 'Page 6',
      component: page6
    },
    {
      path: '/07-water-use',
      name: 'Page 7',
      component: page7
    },
    {
      path: '/08-regional-wu',
      name: 'Page 8',
      component: page8
    },
    {
      path: '/glossary',
      name: 'Glossary',
      component: glossary
    },
    {
      path: '/credits',
      name: 'Credits',
      component: credits
    }
  ]
})

export default router
