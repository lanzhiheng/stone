module Musk
  class CategoriesController < ApplicationController
    before_action :set_category, only: [:show, :edit, :destroy]

    def index
      @categories = Category.all
    end

    def create
      @category = Category.new(category_params)

      if @category.save
        redirect_to musk_category_path(@category), status: 303
      else
        render :new
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
      if @category.destroy
        redirect_to musk_categories_path
      else
        render musk_category_path(@category)
      end
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
