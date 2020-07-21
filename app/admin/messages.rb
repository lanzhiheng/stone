# frozen_string_literal: true

ActiveAdmin.register Message do
  index do
    selectable_column
    id_column
    column :email
    column :name
    column :content
    column :created_at
    actions
  end

  filter :email
  filter :name
end
