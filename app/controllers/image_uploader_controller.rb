# frozen_string_literal: true

class ImageUploaderController < ApplicationController
  def upload
    file = permitted_params[:file]
    name = file.original_filename
    body = file.tempfile

    begin
      obj = aws_bucket.object(name)
      obj.put(body: body)
      render json: { url: url_formatter(obj), name: name }
    rescue StandardError
      render json: { msg: 'upload failed' }, status: 422
    end
  end

  private

  def permitted_params
    params.permit(:file)
  end

  def url_formatter(object)
    region = Aws.config[:region]
    "https://#{object.bucket_name}.s3-#{region}.amazonaws.com/#{object.key}"
  end

  def aws_bucket
    s3 = Aws::S3::Resource.new
    s3.bucket(Rails.application.credentials.dig(:aws, :bucket))
  end
end
