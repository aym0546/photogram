Rails.application.routes.draw do
  get "users/show"
  get "users/edit"
  get "users/update"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'posts#index'

  # プロフィール表示・編集用のカスタムコントローラ
  resource :users, only: [:show, :edit, :update]

end
