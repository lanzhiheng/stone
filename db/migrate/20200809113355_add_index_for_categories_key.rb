class AddIndexForCategoriesKey < ActiveRecord::Migration[6.0]
  def change
    add_index :categories, :key, unique: true
  end
end
