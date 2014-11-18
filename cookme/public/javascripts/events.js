(function() {
  $(function() {
    $('.js--ingredients-container, .js--categories-container').on('fieldset-added', function() {
      return $(".js--fieldset-delete").on('click', function() {
        return $(this).parents('.js--ingredient-form, .js--category-form').hide();
      });
    });
    $(".header--burger").on('click', function() {
      return $('nav').slideToggle(300);
    });
    $(".js--fieldset-delete").on('click', function() {
      return $(this).parents('.js--ingredient-form, .js--category-form').hide();
    });
    $('.js--add-ingredient').on('click', function() {
      var $clone;
      $clone = $('.hidden > .js--ingredient-form').clone();
      $('.js--ingredients-container').append($clone);
      return $('.js--ingredients-container').trigger('fieldset-added');
    });
    return $('.js--add-category').on('click', function() {
      var $clone;
      $clone = $('.hidden > .js--category-form').clone();
      $('.js--categories-container').append($clone);
      return $('.js--categories-container').trigger('fieldset-added');
    });
  });

}).call(this);
