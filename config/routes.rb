Rails.application.routes.draw do
  resources :projects, only: [:index, :new, :create, :show]
  root "projects#index"
end
