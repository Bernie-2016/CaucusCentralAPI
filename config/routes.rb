Rails.application.routes.draw do
  %w(404 422 500).each do |code|
    get code, to: "errors#error_#{code}"
  end

  namespace :api do
    namespace :v1 do
      resources :precincts, except: [:new, :edit]
      resources :sessions, only: [:create] do
        collection do
          delete :destroy
        end
      end
      resources :users do
        collection do
          get :profile
          patch :profile, to: 'users#update_profile'
        end
      end
      resources :invitations, only: [:create]
    end
  end
end
