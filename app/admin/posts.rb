ActiveAdmin.register Post do
  permit_params :title, :body, :slug, :excerpt, :category_id, :created_at

  index do
    selectable_column
    id_column
    column :title
    column :slug
    actions
  end

  filter :title
  filter :created_at

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :title
      f.input :body
      f.input :slug
      f.input :excerpt
      f.input :created_at, :as => :datetime_select
      f.input :category_id, :as => :select, :collection => Category.pluck(:name, :id)
    end
    f.actions
  end

end
