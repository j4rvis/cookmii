$ ->
  $('.js--search-user').data("exclude", [])

  $('.js--search-user').on 'focusin', ->
    if $('.js--search-user').val() isnt ""
      $('.js--search-user').trigger "input"

  $('.js--search-user').on 'focusout', _.debounce ->
    $('.search-user-results').fadeOut()
  , 300

  $('.user-delete').on 'click', (e) ->
    e.preventDefault()
    $(e.target).parent().remove()
    excluded = $('.js--search-user').data("exclude")
    if(excluded.indexOf($(e.target).prev().val())>=0)
      excluded.splice(excluded.indexOf($(e.target).prev().val()), 1)


  $('.search-user-results').on 'click', (event) ->
    if event.target.nodeName is 'P' or event.target.nodeName is 'p'
      $('.search-user-results').parent()
      .append "<div><input class='form-control party--users'
        name='attendees' type='text' value='#{event.target.textContent}' readonly>
        <a href='' class='btn-sm btn-danger user-delete'>Delete</a></div>"
      $('.js--search-user').data("exclude").push(event.target.textContent)
      $('.user-delete').on 'click', (e) ->
        e.preventDefault()
        $(e.target).parent().remove()
        excluded = $('.js--search-user').data("exclude")
        if(excluded.indexOf($(e.target).prev().val())>=0)
          excluded.splice(excluded.indexOf($(e.target).prev().val()), 1)


  $('.js--search-user').on 'input', _.debounce (e) ->
    $('.search-user-results').fadeIn()
    $.post '/search/users',
      search: e.target.value
      excluded: $('.js--search-user').data("exclude")
    .done (data) ->
      $('.search-user-results').text ''
      if _.isEmpty data
        $('.search-user-results').append "<p>Keinen User gefunden.</p>"
      else
        $.each data, (index, element) ->
          $('.search-user-results').append "<p>#{element.username}</p>"
  , 300

  $('.party-delete').on 'click', (e) ->
    e.preventDefault()
    $.ajax $(e.target).attr('href'),
      type: 'delete'
    .done (data) ->
      console.log data

  $('.js--search-recipe').data("exclude", [])

  $('.js--search-recipe').on 'focusin', ->
    if $('.js--search-recipe').val() isnt ""
      $('.js--search-recipe').trigger "input"

  $('.js--search-recipe').on 'focusout', _.debounce ->
    $('.search-recipe-results').fadeOut()
  , 300

  $('.party--recipe-remove').on 'click', (event) ->
    event.preventDefault()
    path = $(event.target).attr('href')
    recipe = $(event.target).data('slug')
    $.post path,
      recipe: recipe
    .done (data) ->
      if(data)
        $(event.target).parent().remove()

  $('.search-recipe-results').on 'click', (event) ->
    if event.target.nodeName is 'P' or event.target.nodeName is 'p'
      $recipe = "<p class='party--recipes' data-slug='#{$(event.target).data('slug')}'>#{event.target.textContent}</p>"
      $.post "#{$('.js--search-recipe').data('slug')}/addrecipe",
        recipe:
          name: $($recipe).text()
          slug: $($recipe).data('slug')
      .done (data) ->
        if data
          $('.recipe-results').append $recipe
          $('.js--search-recipe').data("exclude").push(event.target.textContent)


  $('.js--search-recipe').on 'input', _.debounce (e) ->
    $('.search-recipe-results').fadeIn()
    $.post '/search/recipes',
      search: e.target.value
      excluded: $('.js--search-recipe').data("exclude")
    .done (data) ->
      $('.search-recipe-results').text ''
      if _.isEmpty data
        $('.search-recipe-results').append "<p>Kein Rezept gefunden.</p>"
      else
        $.each data, (index, element) ->
          $('.search-recipe-results').append "<p data-slug='#{element.slug}'>#{element.name}</p>"
  , 300
