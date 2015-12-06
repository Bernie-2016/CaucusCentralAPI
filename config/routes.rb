Rails.application.routes.draw do
  namespace 'api', as: :api do
    devise_for :users, defaults: { format: :json }
  end
end
