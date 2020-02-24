class Category < ApplicationRecord
  has_many :posts
  validates :key, presence: true
  validates :name, presence: true
end
