import { createRouter, createWebHistory } from 'vue-router';
import Books from '../views/Books.vue';
import Readers from '../views/Readers.vue';
import Borrow from '../views/Borrow.vue';
import Dashboard from '../views/Dashboard.vue';

const routes = [
  { path: '/', redirect: '/books' },
  { path: '/books', component: Books },
  { path: '/readers', component: Readers },
  { path: '/borrow', component: Borrow },
  { path: '/dashboard', component: Dashboard }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

export default router;

