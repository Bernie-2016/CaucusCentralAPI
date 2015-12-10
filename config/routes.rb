Rails.application.routes.draw do
  resources :precincts, except: [:new, :edit]
  devise_for :users,
             defaults: { format: :json },
             controllers: {
               invitations: 'invitations',
               sessions: 'sessions'
             }
  root to: 'session#create'
end
