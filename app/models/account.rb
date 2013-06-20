# == Schema Information
#
# Table name: accounts
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  service         :string(255)
#  name_on_service :string(255)
#  id_on_service   :string(255)
#  url             :string(255)
#  tags            :text
#  active          :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Account < ActiveRecord::Base
  attr_accessible :name, :service, :id_on_service, :url, :tags, :active
  
  validates :service, :presence => true
  validates :id_on_service, :presence => true
  validates :url, :presence => true
  
  serialize :tags, Array
  
  has_many :posts

  before_save :set_active_flag
  
  def self.find_by_key(service, id_on_service)
    return nil if service.nil? || id_on_service.nil?
    where(:service => service, :id_on_service => id_on_service).first
  end
  
  def self.active
    self.where(:active => true)
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
    posts.create(post_fields_for(raw_post))
  end
end
