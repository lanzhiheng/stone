# frozen_string_literal: true

module MetaTagsHelper
  def meta_title
    content_for?(:title) ? content_for(:title) : DEFAULT_META['title']
  end

  def meta_description
    content_for?(:description) ? content_for(:description) : DEFAULT_META['description']
  end

  def meta_image
    DEFAULT_META['image']
  end

  def meta_author
    DEFAULT_META['author']
  end

  def meta_keywords
    content_for?(:keywords) ? content_for(:keywords) : DEFAULT_META['keywords']
  end
end
