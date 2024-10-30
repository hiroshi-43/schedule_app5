class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :customer_name, null: false
      t.string :product_name, null: false
      t.string :display_volume, null: false
      t.integer :category_id, null: false, foreign_key: true
      t.date :shipment_date, null: false

      t.timestamps
    end
  end
end
