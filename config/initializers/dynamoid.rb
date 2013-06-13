# See the Dynamoid documentation ()
# and AWS documentation (https://github.com/aws/aws-sdk-ruby)
# for details and other configuration options.
AWS.config({
  :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
#  :dynamo_db_endpoint => ENV['AWS_DYNAMO_DB_ENDPOINT'],
})

# See https://github.com/Veraticus/Dynamoid for configuration options
Dynamoid.configure do |config|
  config.adapter = 'aws_sdk'
  
  config.namespace = ENV['DYNAMO_DB_NAMESPACE']
  
  # Log a warning when a scan rather than a query runs on a table
  config.warn_on_scan = true 
  
  # Don't use Dynamoid's partitioning for now; the benefit is uncertain
  config.partitioning = false
  config.partition_size = 10
  
  # TODO: Profile the application to set read and write throughput properly
  config.read_capacity = 100
  config.write_capacity = 20
end
