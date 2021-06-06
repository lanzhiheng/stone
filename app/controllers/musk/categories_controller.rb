# frozen_string_literal: true

module Musk
  class CategoriesController < ApplicationController
    private

    def category_params
      params.require(:category).permit(%i[key name])
    end
  end
end
