class AddDraftForPost < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :draft, :boolean, default: 1
  end
end
