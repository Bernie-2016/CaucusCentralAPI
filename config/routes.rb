Rails.application.routes.draw do
  devise_for :users,
             defaults: { format: :json },
             controllers: {
               invitations: 'invitations',
               sessions: 'sessions'
             }
  root to: 'session#create'
end
