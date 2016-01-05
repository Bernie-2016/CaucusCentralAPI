Rails.application.routes.draw do
  get '/404', to: 'errors#error_404'
  get '/422', to: 'errors#error_422'
  get '/500', to: 'errors#error_500'
  
  namespace :api do
    namespace :v1 do
      resources :precincts, except: [:new, :edit]
      resources :sessions, only: [:create] do
        collection do
          delete :destroy
        end
      end
    end
  end
end
