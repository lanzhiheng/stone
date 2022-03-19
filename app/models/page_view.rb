# frozen_string_literal: true

class PageView < ApplicationRecord
  validates :post_id, uniqueness: { scope: :remote_ip }
  validates :remote_ip, presence: true
  belongs_to :post
end
