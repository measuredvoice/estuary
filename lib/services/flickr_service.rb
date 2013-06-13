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
      flickr.people.getPublicPhotos(:user_id => nsid, :per_page => 500, :extras => "description,owner_name,date_upload")
    rescue Exception => e
      logger.info "Can't get photos for Flickr account '#{nsid}': #{e}"
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
      return {} 
    end
    
    {
      :name          => registry_account['organization'],
      :service       => shortname,
      :id_on_service => id_on_service,
      :account_url   => registry_account['service_url'],
      :tags          => registry_account['tags'],
    }
  end

  def self.post_fields_for(flickr_data)
    self.flickr_data = flickr_data
    self.id = flickr_data['id']
    self.title = flickr_data['title']
    if flickr_data['description'] && flickr_data['description'] != flickr_data['title']
      self.description = flickr_data['description']
    else
      self.description = ''
    end
    self.ownername = flickr_data['ownername']
    self.uploaded_at = Time.at(flickr_data['dateupload'].to_i)
  end

  def img_url(options={})
    FlickRaw.url(flickr_data)
  end

  def page_url(options={})
    FlickRaw.url_photopage(flickr_data)
  end

  def profile_url(options={})
    FlickRaw.url_profile(flickr_data)
  end

  # Raw interactions with Flickr

  def self.set_flickr_auth
    FlickRaw.api_key = ENV['FLICKR_API_KEY']
    FlickRaw.shared_secret = ENV['FLICKR_API_SECRET']
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def logger
    @logger ||= Logger.new(STDOUT)
  end

end

Service.register(:flickr, FlickrService)
