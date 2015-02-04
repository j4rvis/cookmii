(function() {
  $(function() {
    $('.js--search-user').data("exclude", []);
    $('.js--search-user').on('focusin', function() {
      if ($('.js--search-user').val() !== "") {
        return $('.js--search-user').trigger("input");
      }
    });
    $('.js--search-user').on('focusout', _.debounce(function() {
      return $('.search--results').fadeOut();
    }, 300));
    $('.search--results').on('click', function(event) {
      if (event.target.nodeName === 'P' || event.target.nodeName === 'p') {
        $('.search--results').parent().append("<input class='form-control party--users' name='attendees' type='text' value='" + event.target.textContent + "' readonly>");
        return $('.js--search-user').data("exclude").push(event.target.textContent);
      }
    });
    return $('.js--search-user').on('input', _.debounce(function(e) {
      $('.search--results').fadeIn();
      return $.post('/users/search', {
        search: e.target.value,
        excluded: $('.js--search-user').data("exclude")
      }).done(function(data) {
        $('.search--results').text('');
        if (_.isEmpty(data)) {
          return $('.search--results').append("<p>Keinen User gefunden.</p>");
        } else {
          return $.each(data, function(index, element) {
            return $('.search--results').append("<p>" + element.username + "</p>");
          });
        }
      });
    }, 300));
  });

}).call(this);
