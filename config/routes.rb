Aprende::Application.routes.draw do

  get "home", to: "home#index"
  get "welcome/index"
  get "trivium/:trivia_id/game/new" => "game#new", as: :game_new
  post "trivium/:trivia_id/game/new" => "game#create", as: :game_create
  post "trivium/:trivia_id/game/eval_answer" => "game#eval_answer", as: :game_eval_answer
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

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" , registrations:  "users/registrations" }
  resources :users

  devise_for :teachers, :controllers => {:registrations => "teachers/registrations", :sessions => "teachers/sessions" }

  match 'cities/state_cities', controller: 'cities', action: 'state_cities', as: 'state_cities', via: :get

  resources :teachers

  resources :institutes do
    collection do
      get 'update_city'
    end
  end
  devise_for :admins
  resources :admins

  post 'teachers/inactivate_or_activate' => 'teachers#inactivate_or_activate', as: 'inactivate_or_activate'

  root 'welcome#index'
end
