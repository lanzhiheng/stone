module Musk
  class CategoriesController < ApplicationController
    before_action :set_category, only: [:show, :edit, :destroy]

    def index
      @categories = Category.all
    end

    def create
      @category = Category.new(category_params)

      if @category.save
        flash[:success] = '创建成功'
        redirect_to musk_category_path(@category), status: 303
      else
        flash[:error] = @category.errors.full_messages
        render :new, status: 422
      end
    end

    def show

    end

    def new
      @category = Category.new
    end

    def edit
    end

    def destroy
      @category.destroy
      flash['success'] = '删除成功'
      redirect_to musk_categories_path
    rescue ActiveRecord::InvalidForeignKey => e
      flash['error'] = e.message
      redirect_back(fallback_location: musk_categories_path)
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:key, :name)
    end
  end
end
