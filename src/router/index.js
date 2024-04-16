import { createRouter, createWebHistory } from 'vue-router'
import VisualizationView from '../views/VisualizationView.vue'
import page1 from '../views/page1.vue'
import page2 from '../views/page2.vue'
import page3 from '../views/page3.vue'
import page4 from '../views/page4.vue'
import page5 from '../views/page5.vue'
import page6 from '../views/page6.vue'
import page7 from '../views/page7.vue'
import page8 from '../views/page8.vue'
import page9 from '../views/page9.vue'
import page10 from '../views/page10.vue'


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
      path: '/page1',
      name: 'Page 1',
      component: page1
    },
    {
      path: '/page2',
      name: 'Page 2',
      component: page2
    },
    {
      path: '/page3',
      name: 'Page 3',
      component: page3
    },
    {
      path: '/page4',
      name: 'Page 4',
      component: page4
    },
    {
      path: '/page5',
      name: 'Page 5',
      component: page5
    },
    {
      path: '/page6',
      name: 'Page 6',
      component: page6
    },
    {
      path: '/page7',
      name: 'Page 7',
      component: page7
    },
    {
      path: '/page8',
      name: 'Page 8',
      component: page8
    },
    {
      path: '/page9',
      name: 'Page 9',
      component: page9
    },
    {
      path: '/page10',
      name: 'Page 10',
      component: page10
    }
  ]
})

export default router
