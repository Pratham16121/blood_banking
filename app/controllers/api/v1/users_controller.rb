class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:login]
  before_action :authorize, only: [:index]

  def index
    result = Users::V1::Index.new(current_user).call if current_user
    if result[:status] == 200
      render json: result
    else
      render json: result
    end
  end
  def create
    result = Users::V1::Create.new(user_params = user_params, admin_user = current_user).call
    if result[:status] == 200
      render json: result
    else
      render json: result
    end
  end

  def login
    result = Users::V1::Login.new(user_params).call
    if result['status'] == 200
      render json: result
    else
      render json: result
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :age, :sex, :phone, :blood_type,
                                 :password,
                                 :password_confirmation,
                                 :role_id)
  end
end
