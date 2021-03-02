Rails.application.routes.draw do

  root to: 'homes#top'
  devise_for :admin, controllers: {
    sessions: 'admin/admins/sessions'
  }

  namespace :admin do
    resources :genres, only:[:index, :create, :edit, :update]
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }

  resources :users, only: [:show, :edit, :update]

  get '/users/page/:id/confirm' => 'users#confirm', as: "user_confirm"
  patch '/users/page/:id/confirm' => 'users#quit', as: "user_quit"
  resources :post_books do
    resource :favorites, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end
  resources :books
  get '/books/:id/detail' => 'books#detail', as: "book_detail"

  post 'follow/:id' => 'relationships#follow', as: 'follow'
  delete 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow'
  get 'users/page/:id/relationships' => 'relationships#index', as: 'relationship'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
