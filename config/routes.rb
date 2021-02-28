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

  resources :users, only: [:index, :show, :edit, :update]
  get '/users/page/:id/confirm' => 'users#confirm', as: "user_confirm"
  patch '/users/page/:id/confirm' => 'users#quit', as: "user_quit"
  resources :post_books
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
