Aprende::Application.routes.draw do

  get "home", to: "home#index"
  get "welcome/index"
  get "game/new"
  get "game/question"
  patch "game/eval_answer"
  get "game/reset"
  get "game/finish"
  get "games" => "game#index", as: :games
  get "game/:id/game_results" => "game#game_results", as: :game_results

  resources :questions
  resources :courses
  resources :trivium do
    collection do
      get 'update_course'
    end
    member do
      get  'question' => 'trivium#new_question', as: :new_question
      post 'question' => 'trivium#create_question', as: :create_question
      get  'question/:question_id/edit' => 'trivium#edit_question', as: :edit_question
      patch 'question/:question_id/edit' => 'trivium#update_question', as: :update_question
    end
  end

  devise_for :users, :controllers => {:registrations => "users/registrations"}
  resources :users

  devise_for :teachers, :controllers => {:registrations => "teachers/registrations"}
  resources :teachers


  root 'welcome#index'
end
