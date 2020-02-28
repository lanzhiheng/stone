class PostsController < ApplicationController
  def show
    @post = Post.published.friendly.find(params[:id])
  end

  def index
    category = Category.find_by(key: params[:category])
    @posts = Post.published.where(category: category.id).page(params[:page]).order('created_at DESC')
  end
end
