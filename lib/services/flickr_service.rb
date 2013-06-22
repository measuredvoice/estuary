class FlickrService < Service
  def self.shortname
    :flickr
  end
  
  def self.longname
    "Flickr"
  end
  
  def self.recent_posts_for_account(account)
    set_flickr_auth

    begin
      flickr.people.getPublicPhotos(:user_id => account.id_on_service, :per_page => 500, :extras => "description,owner_name,date_upload")
    rescue Exception => e
      logger.info "Can't get photos for Flickr account '#{account.id_on_service}': #{e}"
      []
    end
  end
  
  def self.account_id_for(registry_account)
    set_flickr_auth
    
    url = registry_account['service_url']
    
    begin
      person = flickr.urls.lookupUser(:url => url)
      person.id
    rescue Exception => e
      logger.info "Can't find Flickr account '#{url}': #{e}"
      # do nothing for this account
      nil
    end
  end
  
  def self.account_fields_for(registry_account)
    id_on_service = account_id_for(registry_account)
    unless id_on_service =~ /@/ 
      logger.info "Flickr account #{registry_account['service_url']} doesn't have a proper NSID."
      return nil 
    end
    
    {
      :name          => registry_account['organization'],
      :service       => shortname,
      :id_on_service => id_on_service,
      :url           => registry_account['service_url'],
      :tags          => registry_account['tags'],
    }
  end
  
  def self.post_id_for(flickr_post)
    flickr_post['id']
  end

  def self.post_fields_for(flickr_post)
    if flickr_post['description'] && flickr_post['description'] != flickr_post['title']
      post_description = flickr_post['description']
    else
      post_description = ''
    end

    {
      :published_at  => Time.at(flickr_post['dateupload'].to_i),
      :title         => flickr_post['title'],
      :description   => post_description,
      :image_url     => FlickRaw.url(flickr_post),
      :permalink_url => FlickRaw.url_photopage(flickr_post),
      :id_on_service => flickr_post['id'],
    }
  end

  # Raw interactions with Flickr

  def self.set_flickr_auth
    FlickRaw.api_key = ENV['FLICKR_API_KEY']
    FlickRaw.shared_secret = ENV['FLICKR_API_SECRET']
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end

Service.register(:flickr, FlickrService)
