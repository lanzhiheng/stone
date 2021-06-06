# frozen_string_literal: true

module Musk
  class PostsController < ApplicationController
    private

    def end_of_association_chain
      Post.friendly
    end

    def post_params
      params.require(:post).permit([:title, :body, :slug, :excerpt, :category_id, :created_at, :draft,
                                    { tag_list: [] }])
    end
  end
end
