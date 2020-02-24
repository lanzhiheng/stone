class AddExcerptForPost < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :excerpt, :string
  end
end
