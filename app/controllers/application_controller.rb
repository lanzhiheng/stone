# frozen_string_literal: true

require 'application_responder'

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  rescue_from ActionController::InvalidAuthenticityToken do |_exception|
    render json: { msg: 'Invalid AuthenticityToken' }, status: 422
  end

  private

  def require_login
    raise ActionController::RoutingError, 'Page Not Found' unless admin_user_signed_in?
  end
end
