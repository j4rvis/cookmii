(function() {
  $(function() {
    $('.js--search-user').data("exclude", []);
    $('.js--search-user').on('focusin', function() {
      if ($('.js--search-user').val() !== "") {
        return $('.js--search-user').trigger("input");
      }
    });
    $('.js--search-user').on('focusout', _.debounce(function() {
      return $('.search-user-results').fadeOut();
    }, 300));
    $('.user-delete').on('click', function(e) {
      var excluded;
      e.preventDefault();
      $(e.target).parent().remove();
      excluded = $('.js--search-user').data("exclude");
      if (excluded.indexOf($(e.target).prev().val()) >= 0) {
        return excluded.splice(excluded.indexOf($(e.target).prev().val()), 1);
      }
    });
    $('.search-user-results').on('click', function(event) {
      if (event.target.nodeName === 'P' || event.target.nodeName === 'p') {
        $('.search-user-results').parent().append("<div><input class='form-control party--users' name='attendees' type='text' value='" + event.target.textContent + "' readonly> <a href='' class='btn-sm btn-danger user-delete'>Delete</a></div>");
        $('.js--search-user').data("exclude").push(event.target.textContent);
        return $('.user-delete').on('click', function(e) {
          var excluded;
          e.preventDefault();
          $(e.target).parent().remove();
          excluded = $('.js--search-user').data("exclude");
          if (excluded.indexOf($(e.target).prev().val()) >= 0) {
            return excluded.splice(excluded.indexOf($(e.target).prev().val()), 1);
          }
        });
      }
    });
    $('.js--search-user').on('input', _.debounce(function(e) {
      $('.search-user-results').fadeIn();
      return $.post('/search/users', {
        search: e.target.value,
        excluded: $('.js--search-user').data("exclude")
      }).done(function(data) {
        $('.search-user-results').text('');
        if (_.isEmpty(data)) {
          return $('.search-user-results').append("<p>Keinen User gefunden.</p>");
        } else {
          return $.each(data, function(index, element) {
            return $('.search-user-results').append("<p>" + element.username + "</p>");
          });
        }
      });
    }, 300));
    $('.party-delete').on('click', function(e) {
      e.preventDefault();
      return $.ajax($(e.target).attr('href'), {
        type: 'delete'
      }).done(function(data) {
        return console.log(data);
      });
    });
    $('.js--search-recipe').data("exclude", []);
    $('.js--search-recipe').on('focusin', function() {
      if ($('.js--search-recipe').val() !== "") {
        return $('.js--search-recipe').trigger("input");
      }
    });
    $('.js--search-recipe').on('focusout', _.debounce(function() {
      return $('.search-recipe-results').fadeOut();
    }, 300));
    $('.party--recipe-remove').on('click', function(event) {
      var path, recipe;
      event.preventDefault();
      path = $(event.target).attr('href');
      recipe = $(event.target).data('slug');
      return $.post(path, {
        recipe: recipe
      }).done(function(data) {
        if (data) {
          return $(event.target).parent().remove();
        }
      });
    });
    $('.search-recipe-results').on('click', function(event) {
      var $recipe;
      if (event.target.nodeName === 'P' || event.target.nodeName === 'p') {
        $recipe = "<p class='party--recipes' data-slug='" + ($(event.target).data('slug')) + "'>" + event.target.textContent + "</p>";
        return $.post("" + ($('.js--search-recipe').data('slug')) + "/addrecipe", {
          recipe: {
            name: $($recipe).text(),
            slug: $($recipe).data('slug')
          }
        }).done(function(data) {
          if (data) {
            $('.recipe-results').append($recipe);
            return $('.js--search-recipe').data("exclude").push(event.target.textContent);
          }
        });
      }
    });
    return $('.js--search-recipe').on('input', _.debounce(function(e) {
      $('.search-recipe-results').fadeIn();
      return $.post('/search/recipes', {
        search: e.target.value,
        excluded: $('.js--search-recipe').data("exclude")
      }).done(function(data) {
        $('.search-recipe-results').text('');
        if (_.isEmpty(data)) {
          return $('.search-recipe-results').append("<p>Kein Rezept gefunden.</p>");
        } else {
          return $.each(data, function(index, element) {
            return $('.search-recipe-results').append("<p data-slug='" + element.slug + "'>" + element.name + "</p>");
          });
        }
      });
    }, 300));
  });

}).call(this);
