# アプリケーション名：CAT'S HAND

# アプリケーションの概要
# 内容  
プロジェクト案件向けのスケジュール管理アプリ  
# ターゲット  
ODM・OEM 受託型企業で働く全体のスケジュールコントロールをしている人  
# ニーズ・課題  
スケジュール変更があった際、スケジュールを把握・管理の煩雑化を解消  
# 目的  
複数の案件 ( 約 20 ~ 30) を1人でさばく為、スケジュール変更業務の負担を減らす。  
顧客都合でスケジュールの変更が多い環境及び昨今の人手不足の為、個に負担が増えていいる。  
スケジュール変更の自動化を推進することでスケジュール変更業務量を減らし、  
今まで時間がなくてできなかった顧客に寄り添った提案業務の時間を創出していく。

## users テーブル

| Column             | Type    | Options                   | 説明           |
| ------------------ | ------- | ------------------------- | -------------- |
| email              | string  | null: false, unique: true | メールアドレス   |
| encrypted_password | string  | null: false               | パスワード      |
| name               | string  | null: false               | 名前           |
| number             | integer | null: false, unique: true | 社員番号        |

上記のユーザーテーブルも追加してください

### Association
- has_many :projects

### Projects
| カラム名         | データ型       | オプション                           | 説明                               |
|-----------------|---------------|-----------------------------------|-----------------------------------|
| customer_name   | string        | null: false                       | 顧客名                              |
| product_name    | string        | null: false                       | 商品名                              |
| display_volume  | string        | null: false                       | 表示容量                            |
| category_id     | integer       | null: false, foreign_key: true    | カテゴリーID（例：化粧品、医薬部外品）|
| shipment_date   | date          | null: false                       | 出荷日                              |


- **Associations**:
  - `has_many :tasks, dependent: :destroy` - ProjectsテーブルはTasksテーブルと1対多のリレーションを持ち、プロジェクト削除時にタスクも削除されます。
  - `belongs_to :category` - ProjectsテーブルはCategoriesテーブルと多対1のリレーションを持っています。

### Categories (ActiveHash)
| カラム名        | データ型       | オプション                           | 説明                               |
|----------------|---------------|-----------------------------------|-----------------------------------|
| id             | integer       | primary_key                       | プライマリキー                      |
| name           | string        | null: false, unique: true         | カテゴリー名                        |

- **Associations**:
  - `has_many :projects` - CategoriesテーブルはProjectsテーブルと1対多のリレーションを持っています。

### Tasks
| カラム名        | データ型       | オプション                           | 説明                               |
|----------------|---------------|-----------------------------------|-----------------------------------|
| project_id     | integer       | null: false, foreign_key: true    | Projectsテーブルの外部キー           |
| name           | string        | null: false                       | タスク名（例：資材発注、出荷など）      |
| start_date     | date          |                                   | タスクの開始日                       |
| end_date       | date          |                                   | タスクの終了日                       |


- **Associations**:
  - `belongs_to :project` - TasksテーブルはProjectsテーブルと多対1のリレーションを持っています。

### LeadTimes
| カラム名        | データ型       | オプション                           | 説明                               |
|----------------|---------------|-----------------------------------|-----------------------------------|
| id             | integer       | primary_key                       | プライマリキー                      |
| task_name      | string        | null: false, unique: true         | タスク名（例：資材発注、資材納品、生産など） |
| duration_days  | integer       | null: false                       | リードタイム（日数）                 |
| created_at     | datetime      | null: false                       | 作成日時                            |
| updated_at     | datetime      | null: false                       | 更新日時                            |

- **Associations**:
  - LeadTimesテーブルは参照データとして機能し、TasksやProjectsとの直接的なリレーションは持ちません。

## Relationships Summary

- **Projects** 1 ⇔ ∞ **Tasks**  
- **Projects** ∞ ⇔ 1 **Categories**
- **Categories** 1 ⇔ ∞ **Projects**
- **LeadTimes** - スケジュール計算のための参照用データ