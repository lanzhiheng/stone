require 'rails_helper'

RSpec.describe ContactController, type: :controller do
  render_views

  describe "GET index" do
    it "has active navbar" do
      get :index
      expect(response.body).to have_tag(".nav > li > a.active", text: "Contact")
    end

    it 'has special html dom' do
      get :index

      expect(response.body).to have_tag("div.contact-form")
      expect(response.body).to have_tag("h1.title", text: "联系方式")
      expect(response.body).to have_tag(".btn", text: "发送")
      expect(response.body).to have_tag(".field", count: 3)
    end
  end
end
