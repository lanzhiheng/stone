class Resume < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true

  def self.markdown
    renderer = Redcarpet::Render::HTML.new(escape_html: true)
    Redcarpet::Markdown.new(renderer, fenced_code_blocks: true)
  end

  def converted_description
    self.class.markdown.render(description).html_safe
  end
end
