module ApplicationHelper
  def soc
    [
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
    ]
  end

  def nav
    [
      {
        title: 'Lastest',
        url: '/'
      },
      {
        title: 'Blog',
        url: '/blogs',
        prefix: true
      },
      {
        title: 'Translation',
        url: '/translations',
        prefix: true
      },
      {
        title: 'About',
        url: '/about'
      },
      {
        title: 'Contact',
        url: '/contact'
      },
    ]
  end

  def navbar
    content_tag(:ul, class: 'nav') do
      nav.map do |item|
        content_tag(:li) do
          attrs = {}
          class_name = current_class(item[:url], item[:prefix])
          attrs[:class] = class_name if class_name.present?
          link_to(item[:title], item[:url], attrs)
        end
      end.join.html_safe
    end
  end

  def social
    content_tag(:ul, class: 'social') do
      soc.map do |item|
        inner = content_tag(:i, '', class: item[:class]).html_safe
        link_to(inner, item[:url], target: '_blank')
      end.join.html_safe
    end
  end

  def current_class(path, prefix=false)
    if prefix
      request.path.index(path)&.zero? ? 'active' : ''
    else
      request.path == path ? 'active' : ''
    end
  end
end
