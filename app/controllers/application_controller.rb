class ApplicationController < ActionController::Base
  load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
    render json: { message: exception.message, authorization_failure: true }, status: :unauthorized
  end
end
