require 'test_helper'

class AboutControllerTest < ActionDispatch::IntegrationTest
  test "should get about page with navbar active" do
    get about_url
    assert_select('.nav > li > a.active', 'About')
  end

  test 'should get about page' do
    get about_url

    assert_select 'div.about' do
      assert_select 'div.english'
      assert_select 'div.english h1.title', "Introduction"
      assert_select 'div.chinese'
      assert_select 'div.chinese h1.title', "简介"
    end
  end
end
