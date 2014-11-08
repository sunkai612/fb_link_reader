class LinksController < ApplicationController
  def index
  	@links = Link.all.order(fb_created_time: :desc)
  end

  def download
  	graph = Koala::Facebook::API.new(current_user.token)
  	links = graph.get_connections("me","links?fields=name,caption,link,created_time&limit=10000")
  	params_link = { linking_id: nil, linking_type: nil, url: nil, name: nil, fb_created_time: nil}
  	links.each do | link |
  		unless Link.find_by_name(link["name"])
  			unless Link.find_by_url(link["link"])
    		  params_link[:linking_id] = current_user.id
    		  params_link[:linking_type] = "User"
      		params_link[:url] = link["link"]
    	  	params_link[:name] = link["name"]
  	  	  params_link[:fb_created_time] = link["created_time"]

  		    Link.create(params_link)
  		  end
  		end
  	end

  	redirect_to links_path
  end
end
