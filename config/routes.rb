require 'sidekiq/web'

Rails.application.routes.draw do

  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'posts#index'

  # プロフィール表示・更新用のカスタムコントローラ
  resource :user, only: [:show, :update]

  resources :posts, only: [:show, :new, :create] do
    resources :comments, only: [:index, :create]
    resource :like, only: [:show, :create, :destroy]
  end

end
