class PostsController < ApplicationController
  def preview
    raise ActionController::RoutingError.new("Page Not Found") unless admin_user_signed_in?
    @post = posts_in_category.friendly.find(params[:id])
    render :show
  end

  def show
    @post = posts_in_category.published.friendly.find(params[:id])
  end

  def index
    @posts = Post.published.where(category: category.id).page(params[:page]).order("created_at DESC")
  end

  private
  def posts_in_category
    category.posts
  end

  def category
    Category.find_by(key: params[:category])
  end
end
