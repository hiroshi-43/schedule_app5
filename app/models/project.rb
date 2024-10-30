class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category

  # スケジュール計算メソッド
  def calculate_schedule
    # 出荷日を基準にリードタイムに従って各タスクの日付を計算
    current_date = self.shipment_date

    # 例：各タスクの計算（仮に生産、資材納品、資材発注の順で）
    production_end_date = current_date
    production_start_date = production_end_date - 14.days
    Task.create(project_id: self.id, name: "生産", start_date: production_start_date, end_date: production_end_date)

    materials_delivery_end_date = production_start_date
    materials_delivery_start_date = materials_delivery_end_date - 14.days
    Task.create(project_id: self.id, name: "資材納品", start_date: materials_delivery_start_date, end_date: materials_delivery_end_date)

    materials_order_end_date = materials_delivery_start_date
    materials_order_start_date = materials_order_end_date - 100.days
    Task.create(project_id: self.id, name: "資材発注", start_date: materials_order_start_date, end_date: materials_order_end_date)
  end
end
