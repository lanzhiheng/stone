require 'rails_helper'

RSpec.describe Comment do
  describe 'association' do
    it { should belong_to(:commentable) }
  end
end
