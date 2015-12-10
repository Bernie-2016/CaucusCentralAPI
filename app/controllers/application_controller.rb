class ApplicationController < ActionController::API
  include AuthConcern

  before_filter :configure_permitted_parameters, if: :devise_controller?

  respond_to :json

  def default_serializer_options
    { root: false }
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation) }
  end
end
