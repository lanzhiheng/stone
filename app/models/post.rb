class Post < ApplicationRecord
  belongs_to :category
  validates :title, presence: true
  validates :body, presence: true
end
