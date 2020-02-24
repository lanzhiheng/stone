class ChangeExcerptFromStringToText < ActiveRecord::Migration[6.0]
  def up
    change_table :posts do |t|
      t.change :excerpt, :text
    end
  end

  def down
    change_table :posts do |t|
      t.change :excerpt, :string
    end
  end
end
