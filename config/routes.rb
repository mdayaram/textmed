Textr::Application.routes.draw do
  root "pages#home"
  get "home", to: "pages#home", as: "home"
  get "inside", to: "pages#inside", as: "inside"


  devise_for :users

  namespace :admin do
    root "base#index"
    resources :users
    resources :messages
  end

  post 'twilio/voice' => 'twilio#voice'
  post 'twilio/sms' => 'twilio#sms'
end
