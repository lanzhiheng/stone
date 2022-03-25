class AddIndexForPost < ActiveRecord::Migration[6.1]
  def change
    add_index(:posts, [:title, :body], using: 'gin', opclass: :gin_trgm_ops)
  end
end
