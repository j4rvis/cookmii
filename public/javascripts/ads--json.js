var json = $.ajax({
  type: "GET",
  dataType: "json",
  url: "http://www2.moviepilot.de/multiad/3.0/1394/0/0/-1/ADTECH;mode=json;plcids=5189847,5189849,5189848,5189850;loc=100;target=_blank;cors=yes",
  async: false,
  success: function (json) {
    console.log( json);
  },
  error: function (e) {
    console.log("error");
  }
});
// var results = [];
// json1.always(function(data){
//   console.log("SUCCESS", data.statusText);
//   $.map(data.ADTECH_MultiAd, function(obj) {
//     if(obj.AdId >= 0){
//       results.push(obj);
//     }
//   });
// });

function reserveSpace(results){
  $.each(results, function(key, val){
    $('#'+ val.PlacementId).width(val.Ad.Creative.SizeWidth);
    $('#'+ val.PlacementId).height(val.Ad.Creative.SizeHight);
    var str = String(val.Ad.AdCode);
    var Str = str.substring(str.indexOf('<start>')+7, str.indexOf('<end>'));
    $('#'+ val.PlacementId).html('<script type="text/javascript">'+Str+'</script>');
    // $('#'+ val.PlacementId).text(str);
  });
}

function showAd(placement){

}