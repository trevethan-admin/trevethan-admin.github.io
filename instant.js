---
---

$(document).ready(function(){

  //slider funtion

  $(function(){
      $('.fadein img:gt(0)').hide();
      setInterval(function(){$('.fadein :first-child').fadeOut(1000).next('img').fadeIn(1000).end().appendTo('.fadein');}, 5000);
  });


  //gallery funtion

  $('#minicontainer img').click(function(){
      $('#mainpic').attr('src',$(this).attr('src').replace('thumb','large'));
  });

  //responsive menu function

  $('#menubutton').click(function(){

  $('.menu').toggle();
  $('#menubutton').toggleClass('button');
  $('#menubutton').toggleClass('button1');

  });

});
