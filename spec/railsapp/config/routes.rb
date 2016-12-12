Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "home#index"

  get "/redirect", to: "home#redirect", as: :redirect
  get "/landing", to: "home#landing", as: :landing
  get "/ajax", to: "home#ajax", as: :ajax
end
