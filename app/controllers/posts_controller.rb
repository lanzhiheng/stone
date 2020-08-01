# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :require_login, only: [:preview]

  def preview
    @post = Post.friendly.find(params[:id])
    render :show
  end

  def show
    @post = Post.published.friendly.find(params[:id])
  end

  def index
    @posts = posts_under_category.published.page(params[:page]).order('created_at DESC')
  end

  private

  def posts_under_category
    Post.category(params[:category])
  end
end
