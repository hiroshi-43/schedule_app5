require 'business_time'

class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy
  accepts_nested_attributes_for :tasks

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category

  # スケジュール計算メソッド
  def calculate_schedule
    # 出荷日を基準に逆算し、各タスクの日程をリードタイムに従って計算
    current_date = self.shipment_date

    # 通常のタスクとリードタイムを順に処理
    task_definitions = [
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

    # 化粧箱関連のタスクとリードタイムを定義
    box_task_definitions = [
      { name: "化粧箱 - 出稿", duration: 14 },
      { name: "化粧箱 - 青焼UP", duration: 7 },
      { name: "化粧箱 - 青焼校了", duration: 7 },
      { name: "化粧箱 - 試刷UP", duration: 14 },
      { name: "化粧箱 - 資材納品", duration: 30 }
    ]

    # 既存タスクを削除
    self.tasks.destroy_all

    # 通常のタスクをリードタイムに従って作成
    task_definitions.each do |task_def|
      end_date = current_date
      start_date = task_def[:duration].business_days.before(end_date)

      # タスクをプロジェクトに関連付けて作成
      self.tasks.create(
        name: task_def[:name],
        start_date: start_date,
        end_date: end_date
      )

      # 現在の日付を次のタスク用に更新
      current_date = start_date
    end

    # 化粧箱スケジュールの開始日を全体スケジュールの「資材納品」の日程から逆算
    current_date = self.tasks.find_by(name: "資材納品")&.start_date

    # 化粧箱のタスクをリードタイムに従って作成
    box_task_definitions.each do |task_def|
      next unless current_date  # 資材納品の日付が設定されている場合のみ実行

      end_date = current_date
      start_date = task_def[:duration].business_days.before(end_date)

      # 化粧箱関連タスクをプロジェクトに関連付けて作成
      self.tasks.create(
        name: task_def[:name],
        start_date: start_date,
        end_date: end_date
      )

      # 次のタスク用に日付を更新
      current_date = start_date
    end
  end
end
