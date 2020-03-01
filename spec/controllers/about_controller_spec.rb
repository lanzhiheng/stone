require 'rails_helper'

RSpec.describe AboutController, type: :controller do
  render_views

  describe "GET index" do
    it "has active navbar" do
      get :index
      expect(response.body).to have_tag(".nav > li > a.active", text: "About")
    end

    it 'has special html dom' do
      get :index

      expect(response.body).to have_tag('div.about')
      expect(response.body).to have_tag("div.english h1.title", text: "Introduction")
      expect(response.body).to have_tag("div.chinese h1.title", text: "简介")
    end
  end
end
