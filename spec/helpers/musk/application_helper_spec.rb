# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Musk::ApplicationHelper, type: :helper do
  it 'alert_area' do
    flash[:notice] = 'Hello'
    expect(alert_area).to have_tag('.alert.success', text: 'Hello')

    flash[:alert] = 'Hello'
    expect(alert_area).to have_tag('.alert.danger', text: 'Hello')
  end
end
