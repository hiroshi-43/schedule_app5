require 'business_time'

class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category

  # スケジュール計算メソッド
  def calculate_schedule
    # 出荷日を基準に逆算し、各タスクの日程をリードタイムに従って計算
    current_date = self.shipment_date

    # タスクとリードタイムを順に処理
    tasks = [
      { name: "出荷", duration: 0 },
      { name: "生産", duration: 14 },
      { name: "資材納品", duration: 14 },
      { name: "資材発注", duration: 100 },
      { name: "注文書受領", duration: 5 },
      { name: "容器試験終了", duration: 7 },
      { name: "容器試験スタート", duration: 40 },
      { name: "容器試験依頼", duration: 20 },
      { name: "処方決定", duration: 3 }
    ]

    # タスクが既に存在する場合は削除
    self.tasks.destroy_all

    # リードタイムに従ってタスクを作成
    tasks.each_cons(2) do |next_task, current_task|
      end_date = current_date
      start_date = current_task[:duration].business_days.before(end_date)  # 営業日数を逆算して取得

      # タスクを作成
      Task.create(
        project_id: self.id,
        name: current_task[:name],
        start_date: start_date,
        end_date: end_date
      )

      # 次のタスクの終了日を更新
      current_date = start_date
    end
  end
end
