class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    render json: { msg: "Invalid AuthenticityToken" }, status: 422
  end
end
