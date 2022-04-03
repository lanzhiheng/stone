# frozen_string_literal: true

class ImageUploaderController < ApplicationController
  def upload
    file = permitted_params[:file]
    filename = file.original_filename

    blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: filename)

    render json: { url: blob.service_url, name: filename }
  end

  private

  def permitted_params
    params.permit(:file)
  end
end
