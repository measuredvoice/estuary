Chef::Log.info("Running deploy/before_migrate.rb...")
 
Chef::Log.info("Symlinking #{release_path}/public/assets to #{new_resource.deploy_to}/shared/assets")

# shared assets hack for opsworks -adh
shared_assets = "#{new_resource.deploy_to}/shared/assets"
if File.exists?(shared_assets) && File.directory?(shared_assets)
    puts "#{shared_assets} directory exists"
else
    puts "creating #{shared_assets} directory..."
    `mkdir -p #{shared_assets}`
end
 
link "#{release_path}/public/assets" do
  to "#{new_resource.deploy_to}/shared/assets"
end
 
rails_env = new_resource.environment["RAILS_ENV"]
Chef::Log.info("Precompiling assets for RAILS_ENV=#{rails_env}...")
 
execute "rake assets:precompile" do
  cwd release_path
  command "bundle exec rake assets:precompile"
  environment "RAILS_ENV" => rails_env
end
