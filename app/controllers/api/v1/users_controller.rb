class Api::V1::UsersController < ApplicationController
  before_action :authorize, only: [:index, :create]

  def login_page
    # render html: "loginpage"
  end
  def index
    if current_user
      render json: { user_data: current_user }, status: 200
    else
      render json: { error_message: 'Login First' }, status: 401
    end
  end
  def create
    user = User.new(user_params)
    user.blood_bank_id = current_user.blood_bank_id
    byebug
    if user.save
      render json: { success_message: 'User created successfully' }, status: 200
    else
      render json: { error_message: user.errors.full_messages.join(', ')}, status: 422
    end
  end

  def login
    user = User.find_by_email(user_params[:email])

    if user && user.authenticate(user_params[:password])
      render json: { token: encode_token({ user_id: user.id, time: Time.now }),
        message: 'Login successful', status: 200 }.as_json
    else
      render json: { error_message: 'Invalid email or password', status: 401 }.as_json
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
