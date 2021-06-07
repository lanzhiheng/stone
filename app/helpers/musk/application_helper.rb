# frozen_string_literal: true

module Musk
  module ApplicationHelper
    def alert_area
      return danger if flash['alert']
      return success if flash['notice']
    end

    def boolean_tag(value)
      option_class = value ? 'tag primary' : 'tag danger'
      text = value ? 'Yes' : 'No'
      content_tag :span, text, class: option_class
    end

    private

    def danger
      content_tag :div, flash['alert'], class: 'alert danger'
    end

    def success
      content_tag :div, flash['notice'], class: 'alert success'
    end
  end
end
