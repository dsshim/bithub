Rails.application.routes.draw do
  get '/auth/github/callback', to: 'sessions#create'
  root 'welcome#index'
  get '/logout', to: 'sessions#destroy'
  get '/dashboard', to: 'users#show'

end
