# frozen_string_literal: true

module Musk
  class PostsController < ApplicationController
    def toggle
      original = resource.draft
      resource.update(draft: !original)
      message = original ? '上架成功' : '下架成功'
      flash[:notice] = "《#{resource.title}》#{message}"
      redirect_back(fallback_location: collection_path)
    end

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
