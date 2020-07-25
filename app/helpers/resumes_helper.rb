# frozen_string_literal: true

module ResumesHelper
  def range(num)
    content_tag :div, class: 'wrapper' do
      (1..5).map do |i|
        content_tag :i, nil, class: "fa fa-bug #{i <= num ? 'check' : ''}"
      end.join.html_safe
    end
  end
end
