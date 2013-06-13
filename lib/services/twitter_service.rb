class TwitterService < Service
  def self.shortname
    :twitter
  end
  
  def self.longname
    "Twitter"
  end
  
end

# Service.register(:twitter, TwitterService)
