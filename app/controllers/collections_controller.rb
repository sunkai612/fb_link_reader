class CollectionsController < ApplicationController
  def index
    query = "links?fields=name,link,created_time&limit=1000000"
    time = current_user.collection_update.to_i.to_s

    query += "&since=" + time

    graph = Koala::Facebook::API.new(current_user.token)
    collections = graph.get_connections("me",query)

    current_user.update({collection_update: Time.now})
    
    params_collection = { user_id: current_user.id,
                          fb_id: nil,
                          name: nil,
                          url: nil,
                          fb_created_time: nil,
                          is_read?: false          }
    
    collections.each do | collection |
      unless Collection.find_by_url(collection["link"])
          params_collection[:fb_id] = collection["id"].to_i
          params_collection[:name] = collection["name"]
          params_collection[:url] = collection["link"]
          params_collection[:fb_created_time] = DateTime.parse(collection["created_time"]).in_time_zone("Taipei")

          Collection.create(params_collection)
      end
    end

    @collections = Collection.where(user_id: current_user.id, is_read?: false).order(created_at: :desc)
  end

  def mark_as_read
    params[:mark_as_read_id].each do |id_to_mark|
      if collection_to_mark = Collection.find(id_to_mark)
        if collection_to_mark.user_id == current_user.id
          collection_to_mark.update({is_read?: true})
        end
      end
    end

    @success = ["status" => "success"]
    respond_to do |f|
      f.json { render json: @success }
    end
  end

  def destroy
    params[:delete_from_collection_id].each do |id_to_delete|
      collection_to_delete = Collection.find(id_to_delete)
      if collection_to_delete.user_id == current_user.id
        collection_to_delete.delete
      end
    end

    @success = ["status" => "success"]
    respond_to do |f|
      f.json { render json: @success }
    end
  end
end
