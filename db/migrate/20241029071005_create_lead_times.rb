class CreateLeadTimes < ActiveRecord::Migration[7.0]
  def change
    create_table :lead_times do |t|
      t.string :task_name, null: false
      t.integer :duration_days, null: false
      t.timestamps
    end
  end
end
