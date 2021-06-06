# frozen_string_literal: true

require 'addressable/uri'
require 'open-uri'
require 'rainbow'

namespace :oss do
  desc 'Upload all url'
  task upload_all_url: [:environment] do
    conn = ActiveRecord::Base.connection
    results = conn.execute('SELECT * FROM map_url_table WHERE new_url IS NULL')

    results.each do |item|
      old_url = item['url']
      desc = item['description']
      begin
        io = URI.parse(old_url).open
        blob = ActiveStorage::Blob.create_and_upload!(io: io, filename: desc)
        new_url = blob.service_url
        conn.execute("UPDATE map_url_table SET new_url = '#{new_url}' WHERE url = '#{old_url}'")
        print Rainbow('.').green
      rescue OpenSSL::SSL::SSLError, URI::InvalidURIError
        puts Rainbow("The #{old_url} could not connect").red
      end
    end
  end
end
