(function() {
  $(function() {
    $('.js--ingredients-container, .js--categories-container').on('fieldset-added', function() {
      return $(".js--fieldset-delete").on('click', function() {
        return $(this).parents('.js--ingredient-form, .js--category-form').remove();
      });
    });
    $(".header--navigation-button").on('click', function() {
      if ($('.header--navigation').css('display') === 'none') {
        if ($('.header--user').css('display') === 'block') {
          $('.header--user').animate({
            width: '10%'
          }, "fast", function() {
            return $(this).hide();
          });
        }
        return $('.header--navigation').show().animate({
          width: '80%'
        }, "fast");
      } else {
        return $('.header--navigation').animate({
          width: '10%'
        }, "fast", function() {
          return $(this).hide();
        });
      }
    });
    $(".header--user-button").on('click', function() {
      if ($('.header--user').css('display') === 'none') {
        if ($('.header--navigation').css('display') === 'block') {
          $('.header--navigation').animate({
            width: '10%'
          }, "fast", function() {
            return $(this).hide();
          });
        }
        return $('.header--user').show().animate({
          width: '80%'
        }, "fast");
      } else {
        return $('.header--user').animate({
          width: '10%'
        }, "fast", function() {
          return $(this).hide();
        });
      }
    });
    $(".js--fieldset-delete").on('click', function() {
      return $(this).parents('.js--ingredient-form, .js--category-form').remove();
    });
    $('.js--add-ingredient').on('click', function() {
      var $clone;
      $clone = $('.hidden > .js--ingredient-form').clone();
      $('.js--ingredients-container').append($clone);
      return $('.js--ingredients-container').trigger('fieldset-added');
    });
    $('.js--add-category').on('click', function() {
      var $clone;
      $clone = $('.hidden > .js--category-form').clone();
      $('.js--categories-container').append($clone);
      return $('.js--categories-container').trigger('fieldset-added');
    });
    $('.js--recipe-delete').on('click', function(event) {
      var confirmation;
      event.preventDefault();
      confirmation = confirm("Möchtest du das Rezept wirklich löschen?");
      if (confirmation) {
        return $.ajax({
          type: 'DELETE',
          url: '/recipes/' + $(this).data('path')
        }).done(function(response) {
          if (response.msg !== '') {
            alert('Error: ' + response.msg);
          }
          return window.location = '/recipes';
        });
      } else {
        return false;
      }
    });
    $('.js--recipe--favorite').on('click', function(event) {
      event.preventDefault();
      return $.ajax({
        type: 'POST',
        url: '/recipes/' + $(this).data('recipe') + '/' + $(this).data('user')
      }).done((function(_this) {
        return function(response) {
          if (response === 'true') {
            $(event.currentTarget).removeClass('fa-star').addClass('fa-star-o');
          } else {
            $(event.currentTarget).removeClass('fa-star-o').addClass('fa-star');
          }
          return $.ajax({
            type: 'GET',
            url: '/recipes/' + $(_this).data('recipe') + '/favcount'
          }).done(function(favCount) {
            return $(event.currentTarget).next().text(favCount);
          });
        };
      })(this));
    });
    return $('.js--recipe--favorite').each(function(i, val) {
      var path;
      path = "/recipes/" + ($(val).data('recipe')) + "/" + ($(val).data('user'));
      return $.get(path, function(data) {
        if (data) {
          return $(val).removeClass('fa-star-o').addClass('fa-star');
        }
      });
    });
  });

}).call(this);
