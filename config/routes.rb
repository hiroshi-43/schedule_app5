Rails.application.routes.draw do
  resources :projects do
    member do
      patch :recalculate  # 再計算ルート
    end
    resources :tasks, only: [:create, :update, :destroy]
  end
  
  root "projects#index"
end
