Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :documents
  root "documents#index"

  mount MilkdownEngine::Engine, at: "/"
end
