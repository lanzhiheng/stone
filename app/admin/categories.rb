# frozen_string_literal: true

ActiveAdmin.register Category do
  permit_params :key, :name

  index do
    selectable_column
    id_column
    column :key
    column :name
    actions
  end

  filter :key
  filter :created_at

  form do |f|
    f.inputs do
      f.input :key
      f.input :name
    end
    f.actions
  end
end
