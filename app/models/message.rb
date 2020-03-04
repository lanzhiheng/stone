class Message < ApplicationRecord
  validates :email, presence: true
  validates :name, presence: true
  validates :content, presence: true
end
