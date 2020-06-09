require 'aws-sdk-s3'

credentials = Aws::Credentials.new(
  Rails.application.credentials.dig(:aws, :access_key_id),
  Rails.application.credentials.dig(:aws, :secret_access_key)
)

region = Rails.application.credentials.dig(:aws, :region)

Aws.config.update({
  region: region,
  credentials: credentials
})
