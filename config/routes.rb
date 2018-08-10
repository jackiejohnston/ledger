Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "transactions#index"
  post "transaction", to: "transactions#create", as: :create_transaction_path
  resources :transactions, only: [:destroy]
  match "transactions/(:year/:month)" => "transactions#index",
    :contraints => { :year => /\d{4}/, :month => /\d{2}/ },
    :as => "transactions_date",
    via: [:get]
end
