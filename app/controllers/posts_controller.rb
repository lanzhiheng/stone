class PostsController < ApplicationController
  def show
    @post = Post.friendly.find(params[:id])
  end

  def index
    category = Category.find_by(key: params[:category])
    @posts = Post.where(category: category.id).page(params[:page]).order('created_at DESC')
  end
end
