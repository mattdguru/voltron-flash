Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'

  get '/redirect', to: 'home#redirect', as: :redirect
  get '/landing', to: 'home#landing', as: :landing
  get '/ajax', to: 'home#ajax', as: :ajax
  get '/error', to: 'home#error', as: :error

  get 'test' => 'test#index'
  get 'page' => 'test#page'
  get 'redirect' => 'test#redirect'
end
