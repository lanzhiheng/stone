# frozen_string_literal: true

module ApplicationHelper
  SOCIAL = [
    {
      class: 'fab fa-github',
      url: 'https://github.com/lanzhiheng'
    },
    {
      class: 'fab fa-weibo',
      url: 'https://www.weibo.com/u/2174832927'
    },
    {
      class: 'fab fa-twitter',
      url: 'https://twitter.com/lanzhiheng'
    },
    {
      class: 'far fa-envelope',
      url: 'mailto:lanzhihengrj@gmail.com'
    },
    {
      class: 'fas fa-rss',
      url: '/lastest.atom'
    }
  ].freeze

  def navbar
    content_tag(:ul, class: 'nav') do
      nav_data.map do |item|
        content_tag(:li) do
          attrs = {}
          class_name = current_class(item[:url])
          attrs[:class] = class_name if class_name.present?
          link_to(item[:title], item[:url], attrs)
        end
      end.join.html_safe
    end
  end

  def social
    content_tag(:ul, class: 'social') do
      SOCIAL.map do |item|
        inner = content_tag(:i, '', class: item[:class]).html_safe
        link_to(inner, item[:url], target: '_blank')
      end.join.html_safe
    end
  end

  def current_class(path)
    if request.path == path || @post && "/#{@post.category.key}" == path
      'active'
    else
      ''
    end
  end

  private

  def nav_data
    categories_navbar = Category.all.map do |category|
      { title: category.name, url: "/#{category.key}" }
    end

    [
      {
        title: 'Lastest',
        url: '/'
      },
      *categories_navbar,
      {
        title: 'About',
        url: '/about'
      },
      {
        title: 'Contact',
        url: '/contact'
      }
    ].freeze
  end
end
