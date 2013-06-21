# == Schema Information
#
# Table name: posts
#
#  id            :integer          not null, primary key
#  published_at  :datetime
#  service       :string(255)
#  id_on_service :string(255)
#  title         :string(255)
#  description   :text
#  image_url     :text
#  permalink_url :text
#  account_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Post < ActiveRecord::Base
  attr_accessible :published_at, :title, :description, :image_url, :permalink_url, :service, :account_id, :id_on_service

  belongs_to :account
  
  validates :published_at,  :presence => true
  validates :id_on_service, :presence => true
  validates :account_id,    :presence => true  
  
  before_save :set_service
  
  # --- Class methods ---
    
  def self.find_by_key(service, id_on_service)
    self.where(:service => service.shortname, :id_on_service => id_on_service).first
  end
  
  def self.most_recent
    order('published_at DESC').limit(20)
  end
  
  def self.recent
    order('published_at DESC')
  end
  
  # --- Instance methods ---
    
  def set_service
    if account_id.present? && service.nil?
      self.service = account.service
    end
  end
  
  def profile_url
    account.url
  end
    
  def ownername
    account.full_display_name
  end
end
