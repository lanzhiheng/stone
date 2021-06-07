# frozen_string_literal: true

module Musk
  class PostsController < ApplicationController
    def toggle
      original = resource.draft
      resource.update(draft: !original)
      message = original ? '上架成功' : '下架成功'
      flash.now[:notice] = "《#{resource.title}》#{message}"

      respond_to do |format|
        format.turbo_stream { render 'musk/posts/toggle', locals: { post: resource } }
        format.html { redirect_back(fallback_location: collection_path) }
      end
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
