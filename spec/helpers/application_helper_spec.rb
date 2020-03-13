require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  describe "sidebar link" do
    it "navbar link" do
      expect(helper.navbar).to have_tag("a", count: 5)
    end

    it "social link" do
      expect(helper.social).to have_tag("a", count: 4)
    end
  end
end
