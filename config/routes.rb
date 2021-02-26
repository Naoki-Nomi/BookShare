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
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
