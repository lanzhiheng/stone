require 'test_helper'

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "404 page" do
    get '/404'
    assert_response :missing
    assert_select 'div.header-content'
    assert_select 'div.error-info' do
      assert_select 'div.error-code', '404'
      assert_select 'div.error-message', 'Not Found'
    end
  end

  test "500 page" do
    get '/500'
    assert_response :error
    assert_select 'div.header-content'
    assert_select 'div.error-code', '500'
    assert_select 'div.error-message', 'Internal Server Error'
  end
end
