require 'rails_helper'

RSpec.describe "Musk::Sessions", type: :request do
  it 'sign in' do
    admin_user = create(:admin_user)
    get musk_root_path
    expect(response.status).to eq(302)
    sign_in(admin_user)
    get musk_root_path
    expect(response.status).to eq(200)
  end

  it 'signout' do
    admin_user = create(:admin_user)
    sign_in(admin_user)
    get musk_root_path
    expect(response.status).to eq(200)

    delete musk_sign_out_path
    get musk_root_path
    expect(response.status).to eq(302)
  end
end
