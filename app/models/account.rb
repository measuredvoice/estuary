class Account
  include Dynamoid::Document

  field :name
  field :service
  field :id_on_service
  field :account_url
  field :tags, :set
  field :active, :boolean
  
  index [:service, :id_on_service]
  
  validates :service, :presence => true
  validates :id_on_service, :presence => true
  validates :account_url, :presence => true
  
  before_save :set_active_flag
  
  def self.find_by_key(service, id_on_service)
    return nil if service.nil? || id_on_service.nil?
    where(:service => service, :id_on_service => id_on_service).first
  end
  
  def set_active_flag
    if active.nil?
      self.active = true
    end
  end
  
  def service_obj
    @service_obj ||= Service.find(service)
  end
  
  def service_shortname
    service_obj.shortname
  end
  
  def service_longname
    service_obj.longname
  end
  
  def full_display_name
    "#{name} on #{service_obj.longname}"
  end
  
  def recent_raw_posts
    service_obj.recent_posts_for_account(self)
  end
  
  def post_fields_for(raw_post)
    service_obj.post_fields_for(raw_post)
  end
  
  def post_id_for(raw_post)
    service_obj.post_id_for(raw_post)
  end
  
  def create_post_for(raw_post)
    fields = post_fields_for(raw_post)
    fields[:account_id] = id
    fields[:service] = service
    post = Post.create(fields)
  end
end
