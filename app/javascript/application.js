// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import Swiper from 'swiper';
import 'swiper/swiper-bundle.css';

document.addEventListener("DOMContentLoaded", function() {
  new Swiper('.swiper-container', {
    slidesPerView: 3,
    spaceBetween: 10,
    loop: false,
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },
  });
});
