var navbar_controll = function(){
  var reloadPage = function(){
    $('.cir').on('click','#reload',function(){
      location.reload();
    });
  };

  var prev = function(){
    $('.nav').on('click','.prev',function(){
      var prevNum = $('#iframe').data('number') - 1;
      var link = $('.link' + prevNum);
      if(link.data('number') == undefined){
        alert("目前顯示的是第一筆");
      } else {
        showLink(link);
      }
    });
  };

  var next = function(){
    $('.nav').on('click','.next',function(){
      var nextNum = $('#iframe').data('number') + 1;
      var link = $('.link' + nextNum);
      if(link.data('number') == undefined){
        alert("目前顯示的是最後一筆");
      } else {
        showLink(link);
      }
    });
  };

  var changeColorWhenChecked = function(){
    $('input').click(function(){
      $(this).parent().parent().children('td').toggleClass('selected');
    });
  };

  var markAsRead = function(){
    $('.cir').on('click','#mark-as-read',function(){
      var selected = [];
      $('input[type=checkbox]:checked').each(function(){
        var checked_id = $(this).attr('value')
        selected.push(checked_id);
        $('tr#'+ $(this).parent().parent().attr('id') +' td').css('background-color','#555555');
      });
      $.ajax('mark_as_read',{
        type: 'POST',
        data: {"mark_as_read_id": selected },
      });
    });
  };

  var saveToCollection = function(){
    $('.cir').on('click','#save',function(){
      var selected = [];
      $('input[type=checkbox]:checked').each(function(){
        var checked_id = $(this).attr('value');
        selected.push(checked_id);
        $('tr#'+ $(this).parent().parent().attr('id') +' td').css('background-color','#e55555');
      });
      $.ajax('save_to_collection',{
        type: 'POST',
        data: {"save_to_collection_id": selected }
      });
    });
  };

  var deleteFromCollection = function(){
    $('.cir').on('click','#delete',function(){
      var selected = [];
      $('input[type=checkbox]:checked').each(function(){
        var checked_id = $(this).attr('value')
        selected.push(checked_id);
        $('tr#'+ $(this).parent().parent().attr('id') +' td').css('background-color','#444444');
      });
      $.ajax('destroy',{
        type: 'POST',
        data: {"delete_from_collection_id": selected },
        success: function(response){
          for(var i=0; i < selected.length; i++){
            $('tr#'+selected[i]).hide('normal',function(){$('tr#'+selected[i]).remove();});
          }
        }
      });
    });
  };

  var openInNewTab = function(){
    $('.cir').on('click','#open',function(){
      var num = $('#iframe').data('number');
      var link = $('.link'+num).data('link');
      window.open(link, '_blank');
    });
  };

  var openLinkList = function(){
    $('.cir').on('click','#cross',function(){
      info = $('.nav').height() + $('.links').height();
      $('#cross').toggleClass('rotate');
      $('.links').slideToggle(600);
      // if($('.nav').css('text-align') == 'center'){
      //   $('.nav').css('text-align','left');
      //   $('.nav').append('<div class="btn next">下一篇</div>');
      //   $('.nav').append('<div class="btn prev">上一篇</div>');
      // } else {
      //   $('.nav').css('text-align','center');
      //   $('.next').remove();
      //   $('.prev').remove();
      // }
    });
  };

  var onClickShowLink = function(controller){
    $('.link').on('click', function(){
      showLink(this);

      var readed_id = $(this).prev().prev().children('input').attr('value');
      var selected = [ readed_id ];
      $('tr#'+ $(this).parent().attr('id') +' td').css('background-color','#555555');

      $.ajax(controller+'/mark_as_read',{
        type: 'POST',
        data: {"mark_as_read_id": selected },
        success: function(response){
          // alert('success!');
        },
        error: function(request, errorType, errorMessage){
          alert(errorType + ': ' + errorMessage);
        }
      });
    });
  };

  var loadMore = function(){
    $('#load-more').on('click',function(){
      $.ajax('next',{
        type: 'POST',
        data: { "last_link_time": $(this).data('time'),
                "data_type":      $(this).data('type')  },
        success: function(response){
          // alert('success!');
          // console.log(a = response);
          var last_link_time = "";
          var countNum = "";
          for(var i=0; i<response.length; i++){
            var tr = "<tr id=" + response[i].link_id + ">" + "</tr>";
            var checkbox = "<td>&nbsp<input id='sharelink' name='sharelink' type='checkbox' value='" +
                           response[i].id + "'>&nbsp</td>";
            
            countNum = $('#load-more').parent().prev().children().first().next().text().replace(/ /g,'');
            countNum = parseInt(countNum.substring(0, countNum.length - 1)) + 1;
            
            var num = "<td>"+countNum+" &nbsp </td>";
            var title = "<td class='link link" + countNum + "' data-link='" +
                        response[i].link.url + "' data-number='" + countNum + "'>" +
                        response[i].link.name.substring(0, 50) + "...</td>";
            
            var time = new Date(response[i].link.fb_created_time);
            time = time.toLocaleString().split(' ');
            time[1] = time[1].substring(2,time[1].length);
            time = time.join(' ');
            
            var create_time = "<td>" + time + "</td>";
            var openNewTab = "<td><a href='"+response[i].link.url+"' target='_blank'>開新分頁</a></td>";

            $('#load-more').parent().before(tr);
            $('#load-more').parent().prev().append(checkbox+num+title+create_time+openNewTab);

            last_link_time = response[i].updated_at;
          }
          $('#load-more').data("time", last_link_time);
          $('#load-more').data("counter", countNum);
          // alert('successfully append 100 new links');
          // console.log(last_link_time);
          // console.log(countNum);
        },
        error: function(request, errorType, errorMessage){
          alert(errorType + ': ' + errorMessage);
        }
      });
    });
  };

  var addSubscription = function(){
    $('.add_subscription').on('click','button',function(){
      $.ajax('subscribed/create',{
        type: 'POST',
        data: { "new_subscription": $('input').val() },
        success: function(response) {
          location.reload();
          alert('你已經成功把 '+response.fb_name+" 加入訂閱"+response.fb_type );
        },
        error: function(request, errorType, errorMessage){
          alert(errorType + ': ' + errorMessage);
        } 
      });
    });
  };

  var removeSubscription = function(){
    $('a').on('click','subscribed',function(e){
      e.preventDefault();
      var unsubscribed_name = $(this).parent().prev().children().text()
      $.ajax('subscribed/destroy',{
        type: 'POST',
        data: { "name": unsubscribed_name },
        success: function(response) {
          location.reload();
          alert('已經成功取消訂閱 '+ unsubscribed_name);
        },
        error: function(request, errorType, errorMessage){
          alert(errorType + ': ' + errorMessage);
        }
      });
    });
  };

  if($('.title').text() == "我的收藏"){
    initialize_iframe();
    reloadPage();
    prev();
    next();
    changeColorWhenChecked();
    markAsRead();
    deleteFromCollection();
    openInNewTab();
    openLinkList();
    onClickShowLink('collections');
    loadMore();
  } else if($('.title').text() == "最新分享"){
    initialize_iframe();
    reloadPage();
    prev();
    next();
    changeColorWhenChecked();
    markAsRead();
    saveToCollection();
    openInNewTab();
    openLinkList();
    onClickShowLink('sharings');
    loadMore();
  } else if($('.title').text() == "已讀清單"){
    initialize_iframe();
    reloadPage();
    prev();
    next();
    // changeColorWhenChecked();
    // markAsRead();
    saveToCollection();
    openInNewTab();
    openLinkList();
    onClickShowLink('sharings');
    loadMore();
  } else if($('.add_subscription h3').text() == "訂閱專頁或對象："){
    addSubscription();
    removeSubscription();
  }
};