Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
   }
  devise_scope :user do
    get 'users/signup_index' => 'users/registrations#index'
    get 'users/logout' => 'users/sessions#edit'
  end

  root "categorys#index"
  resources :users, only: [:show]
  resources :items  do
    collection do
      get 'get_category_children', defaults: { format: 'json' }
      get 'get_category_grandchildren', defaults: { format: 'json' }
    end
    member do
      get 'get_category_children', defaults: { format: 'json' }
      get 'get_category_grandchildren', defaults: { format: 'json' }
    end
    resources :tradings, only:[:new, :create]
    resources :favorites, only: [:create, :destroy],defaults: {format: 'json'}
    resources :item_deliver_addresses, only:[:new, :create, :edit, :update]
  end
  resources :categorys, only: [:index, :show]
  resources :user_cards, only:[:new, :create, :show, :destroy]
  resources :user_addresses, only:[:new, :create, :edit, :update]
  resources :deliver_addresses, only:[:new, :create, :edit, :update]
end


