var initialize_iframe = function(){
  var totalHeight = window.innerHeight;
  var info = $('.nav').height();
  var setIframe = function(){
    setInterval(
      function(){
        totalHeight = window.innerHeight;
        if($('.links').css('display') == 'none'){
          info = $('.nav').height();
        } else {
          info = $('.nav').height() + $('.links').height();
        }
        $('#iframe').css('height',String( totalHeight - info - 5.0001 )+"px");
      },400
    );
  };
  setIframe();
  showLink('.link1');
};