# frozen_string_literal: true

module Musk
  module PostsHelper
    def toggle_link(post)
      link_to post.draft ? '上架' : '下架', toggle_musk_post_path(post), class: 'stone-link', data: { method: 'PUT' },
                                                                     id: "toggle_link_#{post.id}"
    end

    def toggle_button(post)
      link_to post.draft ? '上架' : '下架', toggle_musk_post_path(post), class: 'btn', data: { method: 'PUT' },
                                                                     id: "toggle_button_#{post.id}"
    end
  end
end
