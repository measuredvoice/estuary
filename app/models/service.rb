class Service
  # --- Class methods ---

  def self.register(name, subclass)
    (@services ||= {})[name] = subclass
  end
  
  def self.find(shortname)
    @services[shortname.to_sym]
  end
  
  def self.all
    @services.sort.map do |shortname, service|
      service
    end
  end
  
  def self.shortname
    fail "self.shortname is not defined for this service"
  end
  
  def self.longname
    self.shortname.to_s.humanize
  end
  
end

# Load all service definitions from lib/services/*.rb
Dir[File.join(Rails.root, 'lib', 'services', '**', '*.rb')].each do |f|
  require_dependency f
end
