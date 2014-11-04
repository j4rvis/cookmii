(function() {
  $(function() {
    return $(".header--burger").on('click', function() {
      return $('nav').slideToggle(300);
    });
  });

}).call(this);
