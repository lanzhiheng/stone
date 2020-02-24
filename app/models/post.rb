class Post < ApplicationRecord
  belongs_to :category
  validates :title, presence: true
  validates :body, presence: true

  def self.markdown
    renderer = Redcarpet::Render::HTML.new(escape_html: true)
    Redcarpet::Markdown.new(renderer, extensions = {})
  end

  def content
    self.class.markdown.render(body).html_safe
  end
end
