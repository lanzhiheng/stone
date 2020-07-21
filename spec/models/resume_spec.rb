# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resume, type: :model do
  it 'title must exists' do
    resume = build(:resume, title: '')

    expect do
      resume.save!
    end.to raise_error(ActiveRecord::RecordInvalid)

    resume.title = 'Introduction'
    expect(resume.save).to be true
  end

  it 'description must exists' do
    resume = build(:resume, description: '')
    expect do
      resume.save!
    end.to raise_error(ActiveRecord::RecordInvalid)
    resume.description = 'hello'
    expect(resume.save).to be true
  end

  it 'converted_description is the html result from description attribute' do
    resume = build(:resume, description: '### hello')
    expect(resume.converted_description.strip).to eq('<h3>hello</h3>')
    resume.description = '# hello'
    expect(resume.converted_description.strip).to eq('<h1>hello</h1>')
  end
end
