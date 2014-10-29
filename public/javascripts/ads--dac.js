ADTECH.config.page = {
  protocol: "http",
  server: "www2.moviepilot.de",
  network: '1394',
  pageid: 704423,
  enableMultiAd: true
};
ADTECH.config.placements[5189847] = {
  responsive: {
    useresponsive: true,
    bounds: [
      {
        id: 5189849,
        min: 0,
        max: 1000
      },
      {
        id: 5189847,
        min: 1001,
        max: 9999
      }
    ]
  }
}
//Contentbar
// ADTECH.enqueueAd(5189847);
//Floorad
ADTECH.enqueueAd(5189848);
//Medium Rectangle
ADTECH.enqueueAd(5189849);
//Leaderboard
ADTECH.enqueueAd(5189850);

jQuery(document).ready(function() {
  ADTECH.executeQueue({
    multiAd: {
      disableAdInjection: true,
      skipDefault: true,
      readyCallback: loadReady
    }
  });
});

function loadReady(ids,a){
  ids.forEach(function(entry){
    ADTECH.showAd(entry);
    $('#'+entry).trigger('change');
  });
}

$('.banner').on('change',function(event){
  setTimeout(function(){$(event.target).slideDown( 300);},200);
});