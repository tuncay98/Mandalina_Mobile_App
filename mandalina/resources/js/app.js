/**
 * First we will load all of this project's JavaScript dependencies which
 * includes Vue and other libraries. It is a great starting point when
 * building robust, powerful web applications using Vue and Laravel.
 */

require('./bootstrap');
import router from './router'

window.Vue = require('vue');


/**
 * The following block of code may be used to automatically register your
 * Vue components. It will recursively scan this directory for the Vue
 * components and automatically register them with their "basename".
 *
 * Eg. ./components/ExampleComponent.vue -> <example-component></example-component>
 */

// const files = require.context('./', true, /\.vue$/i)
// files.keys().map(key => Vue.component(key.split('/').pop().split('.')[0], files(key).default))

Vue.component('example-component', require('./components/ExampleComponent.vue').default);
Vue.component('movie-box', require('./components/MovieBox.vue').default);
Vue.component('carousel', require('./components/Carousel.vue').default);
Vue.component('loader-bar', require('./components/Loading.vue').default);
Vue.component('navbar', require('./components/Navbar.vue').default);
Vue.component('player', require('./components/Player.vue').default);
Vue.component('home', require('./components/Home.vue').default);
Vue.component('search', require('./components/Search.vue').default);
/**
 * Next, we will create a fresh Vue application instance and attach it to
 * the page. Then, you may begin adding components to this application
 * or customize the JavaScript scaffolding to fit your unique needs.
 */

Vue.mixin({
    data: function() {
      return {
        get domainlink() {
          return "//filmdizimob.com";
        }
      }
    }
  })

const app = new Vue({
    el: '#app',
    router,
    created: function() {
        this.domainlink = "This won't change it";
      }
    
});

