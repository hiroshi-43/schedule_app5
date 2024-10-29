class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.references :project, null: false, foreign_key: true
      t.string :name, null: false
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
