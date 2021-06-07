# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :posts, dependent: :restrict_with_exception
  validates :key, presence: true, uniqueness: true
  validates :name, presence: true
end
