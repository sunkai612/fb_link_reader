class SharingsController < ApplicationController
  def load
    sources = current_user.subscribeds
    graph = Koala::Facebook::API.new(current_user.token)
    query = "links?fields=name,link,created_time,likes,comments&limit=100&since=" + 3.days.ago.to_i.to_s

    sources.each do |source|
      sharelinks = graph.get_connections(source.fb_id,query)
      puts source.fb_name
      while sharelinks != [] && sharelinks != nil do
        if sharelinks.count > 1
          puts "  ok, going next page of #{source.fb_name}!"
          sharelinks.each do |sharelink|
            save_new_sharings(sharelink, source)
          end
        else
          puts "  last one of #{source.fb_name}"
          save_new_sharings(sharelinks[0], source)
        end
        puts "  finish this page of #{source.fb_name}"
        sharelinks = sharelinks.next_page
      end
    end
    redirect_to sharings_subscribed_path
  end

  def subscribed
    # @sharelinks = Link.includes(:user_link_statuses).where('user_link_statuses.user_id = ? and user_link_statuses.read = ?', current_user.id, false).references(:user_link_statuses).order(fb_created_time: :desc).limit(current_user.show_setting.show_amount)
    @sharelinks = UserLinkStatus.includes(:link).where(user_id: current_user.id, read: false).order(updated_at: :desc).limit(current_user.show_setting.show_amount)
  end

  # def pages
  # end

  # def people
  # end

  def next
    if params[:data_type] = "shared"
      @sharelinks = UserLinkStatus.includes(:link).where('user_id = ? and read = ? and updated_at < ?', current_user.id, false, params[:last_link_time]).order(updated_at: :desc).limit(current_user.show_setting.load_amount)
      respond_to do |f|
        f.json do
          render json: @sharelinks.to_json(only: [:id, :link_id, :publisher, :publish_id, :updated_at], include: { link: {only: [:name, :url, :fb_created_time]} })
        end
      end
    elsif params[:data_type] = "readed"
      @readlinks = UserLinkStatus.includes(:link).where('user_id = ? and read = ? and updated_at < ?', current_user.id, true, params[:last_link_time]).order(updated_at: :desc).limit(current_user.show_setting.load_amount)
      respond_to do |f|
        f.json do
          render json: @readlinks.to_json(only: [:id, :link_id, :publisher, :publish_id, :updated_at], include: { link: {only: [:name, :url, :fb_created_time]} })
        end
      end
    end
  end

  def readed
    # @readlinks = Link.includes(:user_link_statuses).where('user_link_statuses.user_id = ? and user_link_statuses.read = ?', current_user.id, true).references(:user_link_statuses).order(fb_created_time: :desc).limit(current_user.show_setting.show_amount)
    @readlinks = UserLinkStatus.includes(:link).where(user_id: current_user.id, read: true).order(updated_at: :desc).limit(current_user.show_setting.show_amount)
  end

  def mark_as_read
    params[:mark_as_read_id].each do |id_to_mark|
      sharing_to_mark = UserLinkStatus.find(id_to_mark)
      if sharing_to_mark.user_id == current_user.id
        sharing_to_mark.update({read: true})
      end
    end

    @success = ["status" => "success"]
    respond_to do |f|
      f.json { render json: @success }
    end
  end

  def save_to_collection
    params[:save_to_collection_id].each do |id_to_save|
      link_to_save = UserLinkStatus.find(id_to_save)
      if link_to_save.user_id == current_user.id
        params_collection = { fb_id: nil,
                              name: link_to_save.link.name,
                              url: link_to_save.link.url,
                              fb_created_time: link_to_save.link.fb_created_time,
                              is_read?: link_to_save.read?                       }
        Collection.find_or_create_by(params_collection)
      end
    end

    @success = ["status" => "success"]
    respond_to do |f|
      f.json { render json: @success }
    end
  end

  private

  def save_new_sharings(data,source)
    params_link = { name: data["name"],
                    url: data["link"],
                    fb_created_time: DateTime.parse(data["created_time"]) }  
    link = Link.find_or_create_by(params_link)

    params_subscription_link = { subscription_id: source.id,
                                 link_id: link.id,
                                 fb_id: data["id"].to_i }
    SubscriptionLink.find_or_create_by(params_subscription_link)

    params_user_link_status = { user_id: current_user.id, 
                                link_id: link.id,
                                publisher: source.fb_name + " ",
                                publish_id: data["id"] + " ",
                                read: false,
                                is_page?: source.fb_type == "pages" ? true : false,
                                is_ppl?: source.fb_type == "pages" ? false : true   }
    existing_user_link_status = UserLinkStatus.where(user_id: current_user.id, link_id: link.id).first
    if existing_user_link_status
      params_user_link_status = { publisher:  existing_user_link_status.publisher + source.fb_name + " ",
                                  publish_id: existing_user_link_status.publish_id + data["id"] + " ",
                                  is_page?:   existing_user_link_status.is_page? ? true : (source.fb_type == "pages" ? true : false), 
                                  is_ppl?:    existing_user_link_status.is_ppl? ? true : (source.fb_type == "pages" ? false : true)  }
      existing_user_link_status.update(params_user_link_status)
    else
      UserLinkStatus.find_or_create_by(params_user_link_status)
    end
  end
end
