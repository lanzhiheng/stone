# frozen_string_literal: true

class Post < ApplicationRecord
  acts_as_taggable
  extend FriendlyId
  friendly_id :slug, use: :slugged

  belongs_to :category
  validates :title, presence: true
  validates :body, presence: true
  validates :slug, presence: true, uniqueness: true
  has_many :page_views, dependent: :destroy

  scope :published, -> { where(draft: false) }
  scope :drafted, -> { where(draft: true) }

  scope :category, ->(key) { joins(:category).where('categories.key = ?', key) }

  self.per_page = 20

  def self.markdown
    renderer = Redcarpet::Render::HTML.new(escape_html: true, with_toc_data: true)
    Redcarpet::Markdown.new(renderer, fenced_code_blocks: true)
  end

  def click_by(remote_ip)
    PageView.create(post: self, remote_ip: remote_ip)
  end

  def online
    !draft
  end

  def content
    self.class.markdown.render(body).html_safe
  end
end
