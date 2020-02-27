class ErrorsController < ApplicationController
  def not_found
    render(:error_with_code, status: 404)
  end

  def internal_server_error
    render(:error_with_code, status: 500)
  end
end
