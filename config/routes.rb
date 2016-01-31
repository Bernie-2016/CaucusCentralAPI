Rails.application.routes.draw do
  %w(404 422 500).each do |code|
    get code, to: "errors#error_#{code}"
  end

  namespace :api do
    namespace :v1 do
      resources :precincts, only: [:index, :show, :update] do
        post :begin
        post :viability
        post :apportionment
        post :flip

        resources :reports, only: [:show, :create, :update, :destroy]
      end
      resources :sessions, only: [:create] do
        collection do
          post :reset_password
          delete :destroy
        end
      end
      resources :states, only: [:index, :show] do
        get :csv
      end
      resources :users do
        collection do
          post :import
          get :profile
          patch :profile, to: 'users#update_profile'
          post :reset_password
        end
      end
      resources :invitations, only: [:index, :create] do
        post :resend
      end
    end
  end
end
