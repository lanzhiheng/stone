# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from ActionController::InvalidAuthenticityToken do |_exception|
    render json: { msg: 'Invalid AuthenticityToken' }, status: 422
  end
end
