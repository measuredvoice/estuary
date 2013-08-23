class TwitterService < Service
  def self.shortname
    :twitter
  end
  
  def self.longname
    "Twitter"
  end
  
  def self.account_id_for(registry_account)
    if user = account_details_for(registry_account)
      user.id
    else
      nil
    end
  end
  
  def self.account_details_for(registry_account)
    screen_name = registry_account['account']
    
    begin
      sleep 5.seconds
      Twitter.user(screen_name)
    rescue Exception => e
      logger.info "Can't find Twitter account '#{screen_name}': #{e}"
      # do nothing for this account
      nil
    end
  end
  
  def self.account_fields_for(registry_account)
    if user = account_details_for(registry_account)
      id_on_service = user.id
      account_name = "#{user.name} (@#{user.screen_name})"
    else
      return nil
    end
    
    {
      :name          => account_name,
      :service       => shortname,
      :id_on_service => id_on_service,
      :url           => registry_account['service_url'],
      :tags          => registry_account['tags'],
    }
  end
  
  def self.recent_posts_for_account(account)
    begin
      sleep 5.seconds
      Twitter.user_timeline(:user_id => account.id_on_service, :count  => 200, :exclude_replies => true, :include_rts => false)
    rescue Exception => e
      logger.info "Can't get posts for YouTube account '#{account.id_on_service}': #{e}"
      []
    end
  end
  
  def self.post_id_for(tweet)
    tweet.id
  end

  def self.post_fields_for(tweet)
    # Check for photos
    if photo = tweet.media.first
      image_url = photo.media_url + ':medium'
    elsif url = tweet.urls.first
      if url.expanded_url =~ /(png|jpg|gif)$/
        image_url = url.expanded_url
      end
    end
    
    permalink_url = "https://twitter.com/#{tweet.user.screen_name}/statuses/#{tweet.id}"
  
    {
      :published_at  => tweet.created_at,
      :title         => tweet.text,
      :description   => '',
      :image_url     => image_url,
      :permalink_url => permalink_url,
      :id_on_service => tweet.id.to_s,
    }
  end
  
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end

Twitter.configure do |config|
  config.consumer_key    = ENV['TWITTER_CLIENT_KEY']
  config.consumer_secret = ENV['TWITTER_CLIENT_SECRET']
  config.bearer_token    = Twitter.token
end

Service.register(:twitter, TwitterService)
