Rails.application.routes.draw do
  resources :precincts, except: [:new, :edit]
  devise_for :users,
             defaults: { format: :json },
             controllers: { sessions: 'sessions' }
end
