// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.datepicker
//= require casino
//= require foundation
//= require turbolinks
//= require_tree .

$(function(){
  Foundation.libs.abide.settings.patterns.password = /^\S{6,128}$/;
  Foundation.libs.abide.settings.patterns.url = /^(http\:\/\/)?(?!www | www\.)[A-Za-z0-9_-]+\.+[A-Za-z0-9.\/%&=\?_:;-]+$/;
  $(document).foundation();

  $('.phone').mask('(00) 000000000');
  $('.postal_code').mask('00000-000');
  $('.date').mask('00/00/0000');
  $('.date').datepicker({
    dateFormat: 'dd/mm/yy',
    dayNames: ['Domingo','Segunda','Terça','Quarta','Quinta','Sexta','Sábado'],
    dayNamesMin: ['D','S','T','Q','Q','S','S','D'],
    dayNamesShort: ['Dom','Seg','Ter','Qua','Qui','Sex','Sáb','Dom'],
    monthNames: ['Janeiro','Fevereiro','Março','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'],
    monthNamesShort: ['Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'],
    nextText: 'Próximo',
    prevText: 'Anterior',
    changeMonth: true,
    changeYear: true,
    yearRange: "1900:+00"
  });

  $('form.edit_user a.btn').click(function(){ $('input#user_avatar').trigger('click'); });

  $(".flash.notice").css('bottom', '0')
  setTimeout( function(){ $(".flash.notice").css('bottom', '-48px') }, 16000)
  $(document).on('click', '.flash.notice', function(){ $(".flash.notice").css('bottom', '-48px') })
});
