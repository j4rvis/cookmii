$ ->
  $('.js--ingredients-container, .js--categories-container').on 'fieldset-added', ->
    $(".js--fieldset-delete").on 'click', ->
      $(this).parents('.js--ingredient-form, .js--category-form').remove()

  $(".header--navigation-button").on 'click', ->
    if($('.header--navigation').css('display') == 'none')
      if($('.header--user').css('display') == 'block')
        $('.header--user').animate
          width: '10%'
          "fast"
          , -> $(@).hide()
      $('.header--navigation').show().animate({width: '80%'},"fast")
    else
      $('.header--navigation').animate
        width: '10%'
        "fast"
        , -> $(@).hide()

  $(".header--user-button").on 'click', ->
    if($('.header--user').css('display') == 'none')
      if($('.header--navigation').css('display') == 'block')
        $('.header--navigation').animate
          width: '10%'
          "fast"
          , -> $(@).hide()
      $('.header--user').show().animate({width: '80%'},"fast")
    else
      $('.header--user').animate
        width: '10%'
        "fast"
        , -> $(@).hide()

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

  $('.js--recipe--favorite').on 'click', (event) ->
    event.preventDefault()
    $.ajax
      type: 'POST'
      url: '/recipes/' + $(this).data('recipe') + '/' + $(this).data('user')
    .done (response) =>
      if(response == 'true')
        $(event.currentTarget).removeClass('fa-star').addClass('fa-star-o')
      else
        $(event.currentTarget).removeClass('fa-star-o').addClass('fa-star')
      $.ajax
        type: 'GET'
        url: '/recipes/' + $(this).data('recipe') + '/favcount'
      .done (favCount) ->
        $(event.currentTarget).next().text(favCount)

  $('.js--recipe--favorite').each (i,val) ->
    path = "/recipes/#{$(val).data('recipe')}/#{$(val).data('user')}"
    $.get path, (data) ->
      if(data)
        $(val).removeClass('fa-star-o').addClass('fa-star')

