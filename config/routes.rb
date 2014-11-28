Rails.application.routes.draw do
  root to: 'application#index'

  match 'who-we-are', to: 'pages#whoweare', via: :get
  match 'what-we-do', to: 'pages#whatwedo', via: :get
  match 'how-we-work', to: 'pages#howwework', via: :get
  match 'why-zz', to: 'pages#whyzz', via: :get
  match 'contacts', to: 'pages#map', via: :get

  resources :pages
end
