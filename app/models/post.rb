# frozen_string_literal: true

class Post < ApplicationRecord
  acts_as_taggable
  extend FriendlyId
  friendly_id :slug, use: :slugged

  belongs_to :category
  validates :title, presence: true
  validates :body, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :published, -> { where(draft: false) }

  scope :category, ->(key) { joins(:category).where('categories.key = ?', key) }

  self.per_page = 10

  def self.markdown
    renderer = Redcarpet::Render::HTML.new(escape_html: true, with_toc_data: true)
    Redcarpet::Markdown.new(renderer, fenced_code_blocks: true)
  end

  def content
    self.class.markdown.render(body).html_safe
  end
end
