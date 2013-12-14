Aprende::Application.routes.draw do
  get "home", to: "home#index"
  get "welcome/index"
  get "game/new"
  get "game/question"
  patch "game/eval_answer"
  get "game/reset"
  get "game/finish"
  resources :questions

  devise_for :users, :controllers => {:registrations => "users/registrations"}
  resources :users

  root 'welcome#index'
end
