class ApplicationController < ActionController::API
  include CanCan::ControllerAdditions

  around_action :catch_halt

  before_action :set_format!
  before_action :authenticate!
  check_authorization

  rescue_from CanCan::AccessDenied do |_exception|
    catch :halt do
      render_unauthenticated!
    end
  end

  rescue_from ActionController::ParameterMissing do |exception|
    catch :halt do
      render json: { exception.param => 'is required' }, status: 422
    end
  end

  def render(*args)
    super
    throw :halt
  end

  protected

  def catch_halt
    catch :halt do
      yield
    end
  end

  def authenticate!
    token = Token.session.find_by(token: request.headers['Authorization'])
    render_unauthenticated! unless token && token.unexpired?
  end

  def render_unauthenticated!
    render json: {}, status: 403
  end

  def current_token
    @current_token ||= Token.find_by(token: request.headers['Authorization'])
  end

  def current_user
    @current_user ||= current_token.try(:user)
  end

  def set_format!
    request.format = :json
  end
end
