# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactController, type: :controller do
  render_views

  describe 'GET index' do
    it 'has active navbar' do
      get :index
      expect(response.body).to have_tag('.nav > li > a.active', text: 'Contact')
    end

    it 'has special html dom' do
      get :index

      expect(response.body).to have_tag('div.contact-form')
      expect(response.body).to have_tag('form', with: { action: contact_me_path, method: 'post' }) do
        with_tag 'input', with: { name: 'name' }
        with_tag 'input', with: { name: 'email', type: 'email' }
        with_tag 'textarea', with: { name: 'content' }
      end
    end

    it 'meta data for contact page' do
      get :index
      expect(response.body).to have_tag('title', 'Contact Me')
      expect(response.body).to have_tag('meta', with: {
                                          name: 'keywords',
                                          content: DEFAULT_META['keywords']
                                        })
      expect(response.body).to have_tag('meta', with: {
                                          name: 'description',
                                          content: 'Contact the author in this page.'
                                        })
    end
  end
end
