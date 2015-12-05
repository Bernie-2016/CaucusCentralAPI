Rails.application.routes.draw do
  namespace 'api', as: :api do
    devise_for :users
  end
end
