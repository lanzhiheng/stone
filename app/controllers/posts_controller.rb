# frozen_string_literal: true

class PostsController < ApplicationController
  def preview
    raise ActionController::RoutingError, 'Page Not Found' unless admin_user_signed_in?

    @post = posts_under_category.friendly.find(params[:id])
    render :show
  end

  def show
    @post = posts_under_category.published.friendly.find(params[:id])
  end

  def index
    @posts = posts_under_category.published.page(params[:page]).order('created_at DESC')
  end

  private

  def posts_under_category
    Post.category(params[:category])
  end
end
