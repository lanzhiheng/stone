require 'test_helper'

class ContactControllerTest < ActionDispatch::IntegrationTest
  test "should get contact page with navbar active" do
    get contact_url
    assert_select('.nav > li > a.active', 'Contact')
  end

  test 'should get contact page' do
    get contact_url

    assert_select 'div.contact-form' do
      assert_select 'h1.title', '联系方式'
      assert_select 'div.field', 3
      assert_select '.btn', '发送'
    end
  end
end
