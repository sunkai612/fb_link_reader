class SubscribedController < ApplicationController
  def index
    @subscribed_pages = current_user.subscribeds.where(fb_type: 'pages')
    @subscribed_ppl = current_user.subscribeds.where(fb_type: 'people')
  end

  def load_likes
    unless SubscribedObj.where(user_id: current_user.id).first
      graph = Koala::Facebook::API.new(current_user.token)
      subscribed_pages = graph.get_connections("me","likes?fields=name,id&limit=10000")

      params_subscribed_pages = { fb_id: nil, fb_name: nil, fb_type: 'pages' }

      while subscribed_pages != [] do
        subscribed_pages.each do |subscribed_page|
          params_subscribed_pages[:fb_id] = subscribed_page["id"].to_i
          params_subscribed_pages[:fb_name] = subscribed_page["name"]
          page = Subscription.find_or_create_by(params_subscribed_pages)
          SubscribedObj.find_or_create_by({user_id: current_user.id, subscription_id: page.id})
        end
        subscribed_pages = subscribed_pages.next_page
      end
    end

    redirect_to sharings_load_path
  end

  def reload
    
  end

  def create
    new_subscription_id = params[:new_subscription].split('a.')[1].split('&')[0].split('.')[2]
    graph = Koala::Facebook::API.new(current_user.token)
    new_subscription = graph.get_object(new_subscription_id)

    # error handling for weird input isn't build in yet

    fb_type = new_subscription["category"] ? "pages" : "people"
    params_subscription = { fb_id: new_subscription_id,
                            fb_name: new_subscription["name"],
                            fb_type: fb_type }
    subscription = Subscription.find_or_create_by(params_subscription)
    SubscribedObj.find_or_create_by({user_id: current_user.id, subscription_id: subscription.id})

    fb_type = fb_type == "pages" ? "專頁" : "對象"

    puts new_subscription["name"]
    puts fb_type

    @success = { "fb_name"=> new_subscription["name"], "fb_type"=> fb_type }
    respond_to do |f|
      f.json { render json: @success }
    end
  end

  def destroy
    subscription_id = Subscription.find_by_fb_name(params["name"])
    SubscribedObj.where(user_id: current_user.id, subscription_id: subscription_id).first.destroy

    @success = ["status" => "success"]
    respond_to do |f|
      f.json { render json: @success }
    end
  end
end
