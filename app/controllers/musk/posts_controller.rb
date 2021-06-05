module Musk
  class PostsController < ApplicationController
    before_action :set_post, only: [:show, :edit, :destroy]

    def index
      @posts = Post.all
    end

    def new
      @category = Category.new
    end

    def edit
    end

    def update
    end

    private

    def set_post
      @post = Post.friendly.find(params[:id])
    end
  end
end
