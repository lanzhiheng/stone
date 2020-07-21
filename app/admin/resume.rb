# frozen_string_literal: true

ActiveAdmin.register Resume do
  permit_params :title, :description
end
