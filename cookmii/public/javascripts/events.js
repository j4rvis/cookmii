(function() {
  $(function() {
    $('.js--ingredients-container, .js--categories-container').on('fieldset-added', function() {
      return $(".js--fieldset-delete").on('click', function() {
        return $(this).parents('.js--ingredient-form, .js--category-form').remove();
      });
    });
    $(".header--burger").on('click', function() {
      return $('nav').slideToggle(300);
    });
    $(".header--icon").on('click', function() {
      return $('nav').slideToggle(300);
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
    return $('.js--recipe--favorite').on('click', function(event) {
      event.preventDefault();
      return $.ajax({
        type: 'POST',
        url: '/recipes/' + $(this).data('recipe') + '/' + $(this).data('user')
      }).done((function(_this) {
        return function(response) {
          if (response) {
            $(event.currentTarget).removeClass('fa-star-o').addClass('fa-star').css('color', 'orange');
          } else {
            $(event.currentTarget).removeClass('fa-star').addClass('fa-star-o').css('color', 'white');
          }
          return $.ajax({
            type: 'GET',
            url: '/recipes/' + $(_this).data('recipe') + '/favcount'
          }).done(function(response2) {
            return console.log(response2);
          });
        };
      })(this));
    });
  });

}).call(this);
