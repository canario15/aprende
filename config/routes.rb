Aprende::Application.routes.draw do

  get "home", to: "home#index"
  get "home/search" => "home#search", as: :home_search
  get "welcome/index"
  get "companies/edit" => "companies#edit", as: :edit_compnay
  patch "companies/update" => "companies#update", as: :update_company
  get "trivium/:trivia_id/game/new" => "game#new", as: :game_new
  post "trivium/:trivia_id/game/new" => "game#create", as: :game_create
  post "trivium/:trivia_id/game/eval_answer" => "game#eval_answer", as: :game_eval_answer
  post "trivium/:id/clone" => "trivium#clone", as: :clone_trivia
  get "game/reset"
  get "game/finish"
  get "games_teacher" => "game#index_teacher", as: :games_teacher
  get "games_user" => "game#index_user", as: :games_user
  get "game/:id/game_results_teacher" => "game#game_results_teacher", as: :game_results_teacher
  get "game/:id/game_results_user" => "game#game_results_user", as: :game_results_user
  patch "trivium/:trivia_id/games/:id" => "game#update", as: :update_trivium_games

  resources :questions
  resources :courses, :path => 'training'
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

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" , :sessions => "users/sessions",registrations:  "users/registrations" }
  resources :users, :path => 'people' do
    collection do
      post 'create' => 'users#create', as: 'create'
    end
  end

  devise_for :teachers, :controllers => {:registrations => "teachers/registrations", :sessions => "teachers/sessions" }
  devise_scope :teacher do
    get 'teachers/switch', to: 'teachers/sessions#switch', as: :switch_teacher
  end
  match 'cities/state_cities', controller: 'cities', action: 'state_cities', as: 'state_cities', via: :get

  resources :teachers, :path => 'instructors' do
    collection do
      post 'create' => 'teachers#create', as: 'create'
    end
  end

  resources :institutes, :path => 'areas' do
    collection do
      get 'update_city'
    end
  end

  devise_for :admins, :controllers => { :registrations => "admins/registrations", :sessions => "admins/sessions" }
  devise_scope :admin do
    get 'admins/switch', to: 'admins/sessions#switch', as: :switch_admin
  end
  resources :admins
  resources :notifications

  post 'teachers/inactivate_or_activate' => 'teachers#inactivate_or_activate', as: 'inactivate_or_activate'
  post 'notifications/logic_delete' => 'notifications#logic_delete', as: 'logic_delete'

  root 'welcome#index'
end
