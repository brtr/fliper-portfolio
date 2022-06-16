require "sidekiq/pro/web"
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  root to: 'home#index'

  post 'login', to: "users#login", as: :login
  post 'logout', to: "users#logout", as: :logout
  get '/users/:address', to: "users#show", as: :user
  post '/users/sync_flip_records', to: "users#sync_flip_records", as: :sync_user_flip_records
end
