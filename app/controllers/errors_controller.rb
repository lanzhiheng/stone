class ErrorsController < ApplicationController
  def not_found
    error_page_render(404)
  end

  def internal_server_error
    error_page_render(500)
  end

  private
  def error_page_render(code)
    render(:error_with_code, formats: :html, status: code)
  end
end
