ActiveAdmin.register Post do
  permit_params :title, :body, :slug, :excerpt, :category_id, :created_at, :tag_list, :draft

  index do
    selectable_column
    id_column
    column :title
    column :slug
    actions
  end

  show do
    attributes_table do
      row :title
      row :slug
      row :body do |post|
        post.content
      end
      row :tag_list do |post|
        post.tag_list.join(', ')
      end
      row :draft
    end
    active_admin_comments
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
      f.input :tag_list, input_html: { value: f.object.tag_list.join(',') }
      f.input :draft, :as => :boolean
    end

    f.actions
  end

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end
end
