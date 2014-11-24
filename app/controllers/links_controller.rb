class LinksController < ApplicationController
  def news
  	query = "home?fields=from,link,name,caption&limit=100000&since="
    last_news = Link.where(linking_type: "User", linking_id: current_user.id, is_news?: true).order(fb_created_time: :desc).first

    unless last_news
      query += (Time.now.yesterday.to_i).to_s
    else
      last_news_time = DateTime.parse(last_news.fb_created_time).to_i
      if (Time.now.yesterday.to_i) > last_news_time
        query += (Time.now.yesterday.to_i).to_s
      else
        query += last_news_time.to_s
      end
    end

  	graph = Koala::Facebook::API.new(current_user.token)
  	links = graph.get_connections("me",query)
  	params_link = { linking_id: nil,
  		              linking_type: nil,
  		              url: nil,
  		              name: nil,
  		              fb_created_time: nil,
  		              is_news?: true       }
  	links.each do | link |
  		unless Link.find_by_url(link["link"])
    		  params_link[:linking_id] = current_user.id
    		  params_link[:linking_type] = "User"
      		params_link[:url] = link["link"]
    	  	params_link[:name] = link["name"]
  	  	  params_link[:fb_created_time] = link["created_time"]

  		    Link.create(params_link)
  		end
  	end

  	@links = Link.where(linking_id: current_user.id, is_news?: true).order(fb_created_time: :desc)
  end

  def collection
  	# query = "links?fields=name,caption,link,created_time&limit=1000000"
  	# last_col = Link.where(linking_type: "User", linking_id: current_user.id, is_news?: false).order(fb_created_time: :desc).first

   #  if last_col
   #    last_col_time = DateTime.parse(last_col.fb_created_time).to_i
  	# 	query += "&since=" + last_col_time.to_s
   #  end

  	# graph = Koala::Facebook::API.new(current_user.token)
  	# links = graph.get_connections("me",query)
  	# params_link = { linking_id: nil,
  	# 	              linking_type: nil,
  	# 	              url: nil,
  	# 	              name: nil,
  	# 	              fb_created_time: nil,
  	# 	              is_news?: false       }
  	# links.each do | link |
  	# 	unless Link.find_by_url(link["link"])
   #  		  params_link[:linking_id] = current_user.id
   #  		  params_link[:linking_type] = "User"
   #    		params_link[:url] = link["link"]
   #  	  	params_link[:name] = link["name"]
  	#   	  params_link[:fb_created_time] = link["created_time"]

  	# 	    Link.create(params_link)
  	# 	end
  	# end

  	@links = Link.where(linking_id: current_user.id, is_news?: false).order(fb_created_time: :desc)
  end
end
