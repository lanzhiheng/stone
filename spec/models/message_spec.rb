require 'rails_helper'

RSpec.describe Message, type: :model do
  it "email must exists" do
    message = build(:message, email: nil)
    expect {
      message.save!
    }.to raise_error(ActiveRecord::RecordInvalid)

    message.email = 'admin@example.com'
    expect(message.save).to be true
  end

  it "name must exists" do
    message = build(:message, name: nil)
    expect {
      message.save!
    }.to raise_error(ActiveRecord::RecordInvalid)
    message.name = 'hello'
    expect(message.save).to be true
  end

  it "content must exists" do
    message = build(:message, content: nil)
    expect {
      message.save!
    }.to raise_error(ActiveRecord::RecordInvalid)
    message.content = 'hello world.'
    expect(message.save).to be true
  end
end
