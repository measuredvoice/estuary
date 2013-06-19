class Post
  include Dynamoid::Document
  
  # Only one range-indexed field is allowed
  field :published_at, :datetime
  index :published_at, :range => true

  # Dynamoid fields are strings by default
  field :title
  field :description
  field :image_url
  field :permalink_url
  field :service
  field :account_id
  field :id_on_service
  
  field :tags,         :set
  field :publish_date, :string   # Stored as ISO standard 'YYYY-MM-DD'
  
  field :audience,     :integer
  field :kudos,        :integer
  field :reach,        :integer
  field :replies,      :integer
  field :shares,       :integer
  field :metrics_done, :boolean
  
  # Add an index for any set of "where" fields we'll use
  index [:publish_date, :metrics_done]
  index [:service, :id_on_service]
  
  validates :published_at,  :presence => true
  validates :id_on_service, :presence => true
  validates :account_id,    :presence => true
  
  before_save :set_publish_date
  before_save :set_account_fields
  
  # --- Class methods ---
  
  def self.needs_metrics(publish_date)
    # TODO: Make sure the publish date is a valid YYYY-MM-DD
    where(:metrics_done => false, :publish_date => publish_date)
  end
  
  def self.latest_stream
    all.scan_index_forward(false).batch(100).limit(2000)
  end
  
  def self.find_by_key(service, id_on_service)
    self.where(:service => service.shortname, :id_on_service => id_on_service).first
  end
  
  # --- Instance methods ---
  
  def set_publish_date
    return nil if published_at.nil?
    self.publish_date = published_at.strftime('%F')
  end
  
  def set_account_fields
    if account_id.present? && service.nil?
      self.service = account.service
    end
  end
  
  def account
    if account_id.present?
      @account ||= Account.find(account_id)
    end
  end
  
  def account=(a)
    @account = a
    self.account_id = a.id
  end
end