namespace :app do
  desc "Import recent posts for all accounts"
  task :import_all_recent_posts => :environment do
    Account.active.each do |account|
      puts "Getting posts from #{account.full_display_name}..."
      
      account.recent_raw_posts.each do |raw_post|
        id_on_service = account.post_id_for(raw_post)
        
        puts "  checking for post #{id_on_service} on #{account.service}..."
        if Post.find_by_key(account.service_obj, id_on_service)
          puts "  ...already here."
        else
          puts "  ...needs adding..."
          post = account.create_post_for(raw_post)
          if post.present?
            puts "  ...created #{post.id}."
          end
        end
      end
    end
  end

  desc "Import recent posts for accounts on the specified service"
  task :import_recent_posts, [:service] => :environment do |t, params|
    service = Service.find(params[:service])
    puts "All accounts from #{service.longname}..."
    Account.active.where(:service => service.shortname).each do |account|
      puts "Getting posts from #{account.full_display_name}..."
      
      account.recent_raw_posts.each do |raw_post|
        id_on_service = account.post_id_for(raw_post)
        
        puts "  checking for post #{id_on_service} on #{account.service}..."
        if Post.find_by_key(account.service_obj, id_on_service)
          puts "  ...already here."
        else
          puts "  ...needs adding..."
          post = account.create_post_for(raw_post)
          if post.present?
            puts "  ...created #{post.id}."
          end
        end
      end
    end
  end
end
