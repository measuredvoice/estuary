# Specify these secrets as ENV variables on your server,
# or save a copy of this file as config/too_many_secrets.rb

ENV['RAILS_COOKIE_TOKEN'] = "at least 30 characters and all random"

# Dynamoid data storage configuration
#
# See the Dynamoid documentation (https://github.com/Veraticus/Dynamoid)
# or AWS documentation (https://github.com/aws/aws-sdk-ruby)
# for details on where to get these keys.
ENV['AWS_ACCESS_KEY_ID'] = 'key for DynamoDB on AWS'
ENV['AWS_SECRET_ACCESS_KEY'] = 'secret key for DynamoDB on AWS'
ENV['AWS_DYNAMO_DB_ENDPOINT'] = 'endpoint URL for your DynamoDB'
# Use a namespace to separate your estuary tables from other DynamoDB tables
ENV['DYNAMO_DB_NAMESPACE'] = 'my_own_estuary'

# Social media API keys
#
ENV['TWITTER_CLIENT_KEY'] = "XXXXXXXX"
ENV['TWITTER_CLIENT_SECRET'] = "XXXXXXXXX"

ENV['FLICKR_API_KEY'] = "XXXXXXXXXXXXXXXXXXXX"
ENV['FLICKR_API_SECRET'] = "XXXXXXXXXXXXXXXXXXXXXXXX"

ENV['YOUTUBE_API_KEY'] = "XXXXXXXXXXXXXXXXXXXXXXXXXX"
