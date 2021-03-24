Rails.application.routes.draw do
  resources :labels
  get 'sessions/new'
  root 'tasks#index'
  resources :tasks
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show]
  resources :labellings, only: [:create, :destroy]
  namespace :admin do
   resources :users
  end
end
