namespace :app do
  desc "Update active accounts"
  task :update_active_accounts => :environment do
    # List all accounts on known services in the Registry
    registry = Registry::Client.new
    still_active = {}
    Service.all.each do |service|
      puts "Checking #{service.longname} accounts..."
      registry.accounts(:service_id => service.shortname).each do |a|
        puts "  account #{a['account']}..."
        unless account_id = service.account_id_for(a)
          puts "    Can't find a service account ID. Skipping..."
          next
        end
        
        if account = Account.find_by_key(service.shortname, account_id)
          puts "    found #{account.id}"
          account.active = true
        else
          account = Account.new(service.account_fields_for(a))
          puts "    creating..."
        end
        
        if account.save
          puts "    ...saved."
        else
          raise "Can't save account: #{account.inspect}"
        end
        
        still_active[account.id] = true
      end
    end
        
    # Deactivate missing accounts
    puts "Checking for deactivated accounts..."
    Account.all(:batch_size => 100).each do |account|
      puts "  account #{account.id_on_service} on #{account.service}..."
      unless still_active[account.id]
        puts "    is no longer active."
        account.active = false
        account.save
      end
      sleep 0.01
    end
  end
end

