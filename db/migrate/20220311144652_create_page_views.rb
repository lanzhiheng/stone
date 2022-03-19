class CreatePageViews < ActiveRecord::Migration[6.0]
  def change
    create_table :page_views do |t|
      t.string :remote_ip
      t.references :post, null: false, foreign_key: true
      t.index [:post_id, :remote_ip], unique: true

      t.timestamps
    end
  end
end
