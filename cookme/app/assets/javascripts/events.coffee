$ ->

  $('.js--ingredients-container, .js--categories-container').on 'fieldset-added', ->
    $(".js--fieldset-delete").on 'click', ->
      $(this).parents('.js--ingredient-form, .js--category-form').hide()

  $(".header--burger").on 'click', ->
    $('nav').slideToggle(300)

  $(".js--fieldset-delete").on 'click', ->
    $(this).parents('.js--ingredient-form, .js--category-form').hide()

  $('.js--add-ingredient').on 'click', ->
    $clone = $('.hidden > .js--ingredient-form').clone()
    $('.js--ingredients-container').append($clone)
    $('.js--ingredients-container').trigger('fieldset-added')

  $('.js--add-category').on 'click', ->
    $clone = $('.hidden > .js--category-form').clone()
    $('.js--categories-container').append($clone)
    $('.js--categories-container').trigger('fieldset-added')
