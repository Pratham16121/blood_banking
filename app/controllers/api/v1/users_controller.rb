class Api::V1::UsersController < ApplicationController
  before_action :authorize, only: [:index, :create]
  skip_load_and_authorize_resource only: [:login]

  def index
    user_data = current_user if current_user.is_user?
    user_data = User.where(blood_bank_id: current_user.blood_bank_id) if current_user.is_admin?
    user_data = get_user_data_according_to_blood_banks

    if user_data
      render json: { user_data: user_data }, status: 200
    else
      render json: { error_message: 'You have to login' }, status: 401
    end
  end

  def create
    user = User.new(user_params)
    user.blood_bank_id = current_user.blood_bank_id
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

  def get_user_data_according_to_blood_banks
    user_counts = User.group(:blood_bank_id, :role_id).count
    blood_bank_names = BloodBank.where(id: user_counts.keys.map(&:first)).pluck(:id, :name).to_h

    user_counts_by_blood_bank = {}

    user_counts.each do |(blood_bank_id, role_id), count|
      blood_bank_name = blood_bank_names[blood_bank_id]
      user_counts_by_blood_bank[blood_bank_name] ||= { admins: 0, users: 0 }
      if role_id == Role.find_by(name: Role::ROLE[:admin]).id
        user_counts_by_blood_bank[blood_bank_name][:admins] = count
      else
        user_counts_by_blood_bank[blood_bank_name][:users] = count
      end
    end
    user_counts_by_blood_bank.reject! { |key, _| key.nil? }
    user_counts_by_blood_bank
  end
end
