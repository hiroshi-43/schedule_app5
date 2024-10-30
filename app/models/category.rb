class Category < ActiveHash::Base
  self.data = [
    { id: 0, name: '---' },
    { id: 1, name: '化粧品' },
    { id: 2, name: '医薬部外品' },
    { id: 3, name: '健康食品' },
    { id: 4, name: 'その他' }
  ]

  include ActiveHash::Associations
  has_many :projects
end