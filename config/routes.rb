Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'posts#index'

  # プロフィール表示・更新用のカスタムコントローラ
  resource :user, only: [:show, :update]

  resources :posts, only: [:show, :new, :create] do
    resource :like, only: [:show, :create, :destroy]
  end

end
