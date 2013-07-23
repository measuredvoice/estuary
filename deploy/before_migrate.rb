Chef::Log.info("Running deploy/before_migrate.rb...")
 
Chef::Log.info("Symlinking #{release_path}/public/assets to #{new_resource.deploy_to}/shared/assets")

# shared assets hack for opsworks -adh
shared_assets = "#{new_resource.deploy_to}/shared/assets"
#if File.exist?(shared_assets) && File.directory?(shared_assets)
#    Chef::Log.info("Directory #{shared_assets} exists, moving on...")
#else
#    Chef::Log.info("creating #{shared_assets} directory...")
#    `mkdir -p #{shared_assets}`
#end

directory shared_assets do
   owber "deploy"
   group "nginx"
   mode 00755
   action :create 
end
 
link "#{release_path}/public/assets" do
  to shared_assets
end
 
rails_env = new_resource.environment["RAILS_ENV"]
Chef::Log.info("Precompiling assets for RAILS_ENV=#{rails_env}...")
 
execute "rake assets:precompile" do
  cwd release_path
  command "bundle exec rake assets:precompile"
  environment "RAILS_ENV" => rails_env
end
