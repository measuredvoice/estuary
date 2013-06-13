class Account
  include Dynamoid::Document

  field :name
  field :service
  field :id_on_service
  field :account_url
  field :tags, :set
  field :active, :boolean

  has_many :posts
  
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
end
