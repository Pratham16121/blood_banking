class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
    if exception.action == :create && exception.subject.is_a?(BloodRequest)
      render json: { message: "Recipent must be registerd with blood bank" }, status: :unauthorized
    elsif exception.action == :create && exception.subject.is_a?(Donation)
      render json: { message: "Donar must be registerd with blood bank" }, status: :unauthorized
    else
      render json: { message: exception.message, authorization_failure: true }, status: :unauthorized
    end
  end

  def current_user
    @current_user ||= User.find_by_id(decode_token[0]['user_id'])
  end
  
  def encode_token(token)
    JWT.encode(
      token,
      Rails.application.secrets.secret_key_base
    )
  end

  def decode_token
    auth_header = request.headers['Authorization'] 
    token = auth_header ? auth_header.split(' ')[1] : params[:auth]
    JWT.decode token, Rails.application.secrets.secret_key_base, 'HS256'
  rescue JWT::DecodeError
    nil
  end

  def authorized_user
    decoded_token = decode_token
    if decoded_token
      user_id = decoded_token[0]['user_id']
      if User.exists? user_id
        @user = User.select(:id, :name, :email, :role_id).find user_id
        true
      else
        render status: 400
      end
    end
  end

  def authorize
    render json: { error_message: 'You have to log in' }, status: :unauthorized unless authorized_user
  end
end
