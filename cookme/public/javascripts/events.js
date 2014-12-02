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
    return $('.js--recipe-delete').on('click', function(event) {
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
  });

}).call(this);
