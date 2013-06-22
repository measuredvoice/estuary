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
        if account = Account.find_by_url(a['service_url'])
          puts "    found #{account.id}"
          account.active = true
        else
          if fields = service.account_fields_for(a)
            account = Account.new(fields)
            puts "    creating..."
          else
            puts "    no account found."
            next
          end
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
    Account.all.each do |account|
      puts "  account #{account.id_on_service} on #{account.service}..."
      unless still_active[account.id]
        puts "    is no longer active."
        account.active = false
        account.save
      end
    end
  end
end

