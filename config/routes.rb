Rails.application.routes.draw do
  get 'groups/new'
  get 'groups/edit'
  get 'groups/show'
  get 'groups/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users

  root to: "homes#top"
  get "home/about"=>"homes#about"



  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :users do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  resources :groups, only: [:index, :show, :edit, :new, :create, :destroy, :update] do
    resource :group_users, only: [:create, :destroy, :index]
    get 'join' => "group_users#join"
    delete 'leave' => "group_users#leave"
    get 'new/mail' => "groups#new_mail"
    get 'send/mail' => "groups#send_mail"

  end

  get "search" => "searches#search"

end