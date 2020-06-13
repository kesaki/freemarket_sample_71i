Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations'
   }
  root "categorys#index"
  resources :users, only: [:index, :edit]
  resources :items, only: [:index, :show, :new]
  resources :categorys, only: [:index, :show]
  resources :user_addresses, only:[:new, :edit]
  resources :deliver_addresses, only:[:new, :edit]
end
