Rails.application.routes.draw do
  get 'session/new'

  get 'user/new'

  root 'main#index'

  get "log_out" => "session#destroy", :as => "log_out"
  get "log_in" => "session#new", :as => "log_in"
  get "sign_up" => "user#new", :as => "sign_up"

  get 'credit_applyment/applyment/:id', to: 'credit_administrate#applyment', as: :applyment
  get 'current_credit/info/:id', to: 'credit_administrate#current_credit', as: :credit_info
  get 'current_credit/close/:id', to: 'credit_administrate#close', as: :credit_close
  get 'credit_applyment/decline/:id', to: 'credit_administrate#applyment_decline', as: :applyment_decline
  get 'credit_applyment/confirmation/:id', to: 'credit_administrate#applyment_confirmation', as: :applyment_confirmation
  get 'current_information/print/:id', to: 'credit_administrate#print_credit', as: :credit_print_info

  namespace :api do
    get "credit_information/:id" => 'credit#get_extra_information_by_id'
  end


  resources :online_credit, :bank_credit, :credit_payment
  resources :credit_administrate, only: [:index]

  resources :user
  resources :session

  namespace :client_account do
    resource :accounts, :cards, :credits
    get 'show_credit/:id', to: 'credits#show_credit', as: 'show_credit'
    get 'show_account/:id', to: 'accounts#show_account', as: 'show_account'
  end
  namespace :operator do
    resources :users
    resources :credits
    get 'users/:id/update_password', to: 'users#update_password', as: 'user_update_password'
    get  'timemachine/new',       to: 'timemachine#new'
    post 'timemachine/create',    to: 'timemachine#create'
  end

  namespace :cashier do
    resources :cashbox
    resources :credit_payments
    get '/credit_payments/:credit_id/:payment_id/pay/:sum/:penalty_sum', to: 'credit_payments#pay', as: 'credit_payment_pay'
  end
end
