class ErrorsController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate!

  def error_404
    render(:json, nothing: true, status: 404)
  end

  def error_422
    render(:json, nothing: true, status: 422)
  end

  def error_500
    render(:json, nothing: true, status: 500)
  end
end
