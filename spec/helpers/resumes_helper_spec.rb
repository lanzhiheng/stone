# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResumesHelper do
  it 'range' do
    expect(range(0)).to have_tag('i.fa.fa-bug', count: 5)
    expect(range(0)).not_to have_tag('i.check')

    expect(range(4)).to have_tag('i.fa.fa-bug', count: 5)
    expect(range(4)).to have_tag('i.fa.fa-bug.check', count: 4)
  end
end
