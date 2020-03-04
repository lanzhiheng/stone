class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :email
      t.string :name
      t.text :content

      t.timestamps
    end
  end
end
