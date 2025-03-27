Rails.application.routes.draw do
  devise_for :users

  # 🔄 Nouvelle landing page publique
  root to: "pages#landing"

  # 🔐 Page de scan protégée
  get "/scan", to: "pages#scan"
  post "/scan", to: "workarts#scan"

  get "error", to: "pages#error"
  post "tts", to: "pages#tts", as: :tts

  get "up" => "rails/health#show", as: :rails_health_check

  resources :workarts, only: [:index, :show] do
    member do
      post :schedule_email
    end

    resources :user_workarts, only: [:create]
  end

  resources :user_workarts, only: [:destroy]
end
