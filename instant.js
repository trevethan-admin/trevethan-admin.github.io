---
---

$(document).ready(function(){

  //slider funtion

  $(function(){
    $('.sliding-gallery img:gt(0)').hide();
    setInterval(function(){$('.sliding-gallery :first-child').fadeOut(1000).next('img').fadeIn(1000).end().appendTo('.sliding-gallery');}, 5000);
  });


  //gallery funtion

  $('.mini-container li img').click(function(){
    $('.main-pic').attr('src',$(this).attr('src').replace('thumb','large'));
  });

  //responsive menu function

  $('.menubutton').click(function(){

  $('.menu').toggle();
  $('#menubutton').toggleClass('button');
  $('#menubutton').toggleClass('button1');

  });

});
