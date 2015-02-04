$ ->
  $('.js--search-user').data("exclude", [])

  $('.js--search-user').on 'focusin', ->
    if $('.js--search-user').val() isnt ""
      $('.js--search-user').trigger "input"

  $('.js--search-user').on 'focusout', _.debounce ->
    $('.search--results').fadeOut()
  , 300

  $('.search--results').on 'click', (event) ->
    if event.target.nodeName is 'P' or event.target.nodeName is 'p'
      $('.search--results').parent()
      .append "<input class='form-control party--users' name='attendees' type='text' value='#{event.target.textContent}' readonly>"
      $('.js--search-user').data("exclude").push(event.target.textContent)

  $('.js--search-user').on 'input', _.debounce (e) ->
    $('.search--results').fadeIn()
    $.post '/users/search',
      search: e.target.value
      excluded: $('.js--search-user').data("exclude")
    .done (data) ->
      $('.search--results').text ''
      if _.isEmpty data
        $('.search--results').append "<p>Keinen User gefunden.</p>"
      else
        $.each data, (index, element) ->
          $('.search--results').append "<p>#{element.username}</p>"
  , 300

