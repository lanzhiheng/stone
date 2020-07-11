require 'rails_helper'

RSpec.describe ResumesController, type: :controller do
  render_views

  it "display first two resumes" do
    (1..3).each do |i|
      create(:resume, title: "title-#{i}", description: "## hello#{i}")
    end
    get :index
    expect(response.body).to have_tag('.resume', count: 2)
  end
end
