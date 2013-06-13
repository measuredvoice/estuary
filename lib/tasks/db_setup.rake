namespace :db do
  desc "Set up the initial DynamoDB database tables"
  task :prepare => :environment do
    puts "Setting up the DynamoDB database tables."
    puts "This may take a while..."
    
    puts "Adding accounts..."
    account = Account.new(
      :name          => "Test", 
      :service       => :test, 
      :id_on_service => 'testtesttest', 
      :account_url   => 'http://example.com/test', 
      :active        => false
    )
    account.save
    
    puts "Adding posts..."
    post = Post.new(
      :title => "First post", 
      :published_at => Time.zone.now,
      :service => :test,
      :id_on_service => 'testtesttest',
      :account => account,
    )
    post.save
    
    puts "Clearing test data..."
    
    puts "Tables are set up."
  end
end
