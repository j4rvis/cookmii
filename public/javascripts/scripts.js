$(function(){
  // Set required fields
  $('.template-variables').each(function(){
    if($(this).attr('isrequired') == 'true'){
      $(this).attr('required', true);
    }
  });

  // Remove fileupload fields from the sidebar
});

if(window.location.search != ''){
  $('.sidebar, .navi').toggle();

	content = $('.unparsed-code').text();
  var QueryString = function () {
    // This function is anonymous, is executed immediately and
    // the return value is assigned to QueryString!
    var query_string = {};
    var query = window.location.search.substring(1);
    var vars = query.split("&");
    for (var i=0;i<vars.length;i++) {
      var pair = vars[i].split("=");
        // If first entry with this name
      if (typeof query_string[pair[0]] === "undefined") {
        query_string[pair[0]] = decodeURIComponent(pair[1]);
        // If second entry with this name
      } else if (typeof query_string[pair[0]] === "string") {
        var arr = [ query_string[pair[0]], decodeURIComponent(pair[1]) ];
        query_string[pair[0]] = arr;
        // If third or later entry with this name
      } else {
        query_string[pair[0]].push(decodeURIComponent(pair[1]));
      }
    }
      return query_string;
  } ();
  for( var key in QueryString){
    // console.log(decodeURIComponent(QueryString[key]));
    content = content.replace(new RegExp('\\['+key+'\\]',"g"), decodeURIComponent(QueryString[key]));
  }
  content = content.replace(new RegExp('_ADPATH_null',"g"), '');
  content = content.replace(new RegExp('_ADCLICK_',"g"), '');
  content = content.replace(new RegExp('_ADBNID_',"g"), '12345678');
  // console.log(content);
	$(".sample").html(content);
}

$('.sidebar-toggle').on('click', function(){
  $('.sidebar,.navi').toggle();
});