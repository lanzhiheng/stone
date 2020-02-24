class PostsController < ApplicationController
  def show
    @post = Post.find_by!(slug: params[:slug])
  end

  def index
    category = Category.find_by(key: params[:category])
    @posts = Post.where(category: category.id).page(params[:page]).order('created_at DESC')
  end
end
