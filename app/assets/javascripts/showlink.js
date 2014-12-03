// error handling for iframe
var list = ['stackoverflow','developer.chrome.com']

var showLink = function(source){
  var link = $(source).data('link');
  var num = $(source).data('number');
  if(link.indexOf('www.slideshare.net') > 0){
    var url = link.split('-');
    var tail = url[url.length - 1];
    link = "//www.slideshare.net/slideshow/embed_code/"+tail;
    $('#iframe').removeAttr('sandbox');
    alert("有些 slideshare 會無法正常顯示，若遇到時可以點選在新頁面開啓試試看");
  } else if(link.indexOf('www.youtube.com') > 0) {
    var url = link.split('=');
    var tail = url[url.length - 1];
    link = "//www.youtube.com/embed/"+tail
    $('#iframe').removeAttr('sandbox')
  } else if (link.indexOf('www.ted.com') > 0) {
    var url = link.split('/');
    var tail = url[url.length - 1];
    link = "https://embed-ssl.ted.com/talks/"+tail+".html"
    $('#iframe').removeAttr('sandbox')
    alert("有些 TED 會無法正常顯示，若遇到時可以點選在新頁面開啓試試看")
  } else {
    var i = 0;
    while( i < list.length ){
      if(link.indexOf(list[i]) > 0){
        alert(list[i]+"不支援鑲嵌網頁，請觀看新視窗");
        window.open(link);
        i += list.length;
      } else {
        i++;
      }
    }
    $('#iframe').attr('sandbox','');
  }
  $('#iframe').attr('src',link).data('number',num);
};