Rails.application.routes.draw do
  root to: 'homes#top'
  devise_for :admin, controllers: {
    sessions: 'admin/admins/sessions'
  }

  namespace :admin do
    resources :genres, only: [:index, :create, :edit, :update]
    root to: 'homes#top'
    resources :users, only: [:edit, :update]
    resources :post_books, only: [:index, :show, :destroy] do
      resources :comments, only: [:destroy]
    end
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }

  resources :users, only: [:show, :edit, :update]
  resources :notifications, only: [:index]
  delete '/notifications' => 'notifications#destroy_all', as: "destroy_all_notification"

  get '/users/page/:id/confirm' => 'users#confirm', as: "user_confirm"
  patch '/users/page/:id/confirm' => 'users#quit', as: "user_quit"
  resources :post_books do
    resource :favorites, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
    get :search, on: :collection
  end
  resources :favorites, only: [:index] do
    get :search, on: :collection
  end

  get '/book/:user_id/detail' => 'books#detail', as: "detail"
  resources :books do
    get :search, on: :collection
  end

  post 'follow/:id' => 'relationships#follow', as: 'follow'
  delete 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow'
  resources :relationships, only: [:index] do
    get :search, on: :collection
  end

  resources :contacts, only: [:new, :create]
  post 'contact/confirm' => 'contacts#confirm'
  get 'contact/thanks' => 'contacts#thanks'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
