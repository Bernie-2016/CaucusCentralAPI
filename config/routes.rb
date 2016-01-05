Rails.application.routes.draw do
  root to: 'session#create'

  devise_for :users,
    defaults: { format: :json },
    controllers: {
      invitations: 'api/v1/invitations',
      sessions: 'api/v1/sessions'
    }

  devise_scope :user do
    namespace :api do
      namespace :v1 do
        resources :invitations, only: [:create]
        resources :sessions, only: [:create, :destroy]
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :precincts, except: [:new, :edit]
    end
  end
end
