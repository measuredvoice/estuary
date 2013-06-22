class YoutubeService < Service
  def self.shortname
    :youtube
  end
  
  def self.longname
    "YouTube"
  end
  
  def self.recent_posts_for_account(account)
    begin
      client.videos_by(:user => account.id_on_service, :per_page => 20).videos
    rescue Exception => e
      logger.info "Can't get posts for YouTube account '#{account.id_on_service}': #{e}"
      []
    end
  end
  
  def self.account_id_for(registry_account)
    registry_account['account']
  end
  
  def self.account_fields_for(registry_account)
    {
      :name          => registry_account['organization'],
      :service       => shortname,
      :id_on_service => registry_account['account'],
      :url           => registry_account['service_url'],
      :tags          => registry_account['tags'],
    }
  end
  
  def self.post_id_for(youtube_post)
    youtube_post.video_id
  end

  def self.post_fields_for(youtube_post)
    {
      :published_at  => youtube_post.uploaded_at,
      :title         => youtube_post.title,
      :description   => youtube_post.description,
      :image_url     => youtube_post.thumbnails.second.url,
      :permalink_url => youtube_post.player_url,
      :id_on_service => youtube_post.video_id,
    }
  end

  # Raw interactions with YouTube

  def self.client
    @client ||= YouTubeIt::Client.new(:dev_key => ENV['YOUTUBE_API_KEY'])
  end
  
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end

Service.register(:youtube, YoutubeService)
