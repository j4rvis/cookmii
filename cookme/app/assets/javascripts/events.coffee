$ ->

  $('.js--ingredients-container, .js--categories-container').on 'fieldset-added', ->
    $(".js--fieldset-delete").on 'click', ->
      $(this).parents('.js--ingredient-form, .js--category-form').remove()

  $(".header--burger").on 'click', ->
    $('nav').slideToggle(300)

  $(".js--fieldset-delete").on 'click', ->
    $(this).parents('.js--ingredient-form, .js--category-form').remove()

  $('.js--add-ingredient').on 'click', ->
    $clone = $('.hidden > .js--ingredient-form').clone()
    $('.js--ingredients-container').append($clone)
    $('.js--ingredients-container').trigger('fieldset-added')

  $('.js--add-category').on 'click', ->
    $clone = $('.hidden > .js--category-form').clone()
    $('.js--categories-container').append($clone)
    $('.js--categories-container').trigger('fieldset-added')

  $('.js--recipe-delete').on 'click', (event)->
    event.preventDefault()
    confirmation = confirm("Möchtest du das Rezept wirklich löschen?")
    if(confirmation)
      $.ajax
        type: 'DELETE'
        url: '/recipes/' + $(@).data('path')
      .done (response) ->
        if (response.msg != '')
          alert('Error: ' + response.msg)
        window.location = '/recipes'
    else
      false