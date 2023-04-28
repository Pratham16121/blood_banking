class UsersController < ApplicationController
  before_action :authorize, only: [:create]
  skip_load_and_authorize_resource only: [:login, :index]

  def logout
    cookies.delete(:auth_token)
    flash[:error] = "Logged out"
    redirect_to root_path
  end

  def search
    @result = User.select(:id, :name, :email).where(blood_bank_id: current_user.blood_bank_id)
            .where.not(id: current_user.id)
            .where("email LIKE ?", "%#{params[:query]}%")
    render json: @result
  end

  def index
    if cookies[:auth_token]
      if current_user.is_super_admin?
        user_data = get_user_data_according_to_blood_banks
      elsif current_user.is_admin?
        user_data = User.select(:name, :email, :blood_type, :age, :sex, :phone)
                        .where(blood_bank_id: current_user.blood_bank_id, role_id: 3)
        blood_requests = BloodRequest.where(blood_bank_id: current_user.blood_bank_id)
                        .group_by(&:is_completed?)
        @blood_requests = { pending: blood_requests[false] || [],
                        completed: blood_requests[true] || [] }
      else
        user_data = current_user.as_json(only: [:id, :name, :email, :blood_type, :age, :sex, :phone])
      end

      if user_data
        @blood_requests_to_display = @blood_requests[:pending]
        @users_data = user_data
        unless flash[:success]
          flash[:success] = "Logged In"
        end
      end
    end
  end

  def create
    user = User.new(user_params)
    user.blood_bank_id = current_user.blood_bank_id if !user_params[:blood_bank_id].present?
    if user.save
      flash[:success] = "User Saved"
      redirect_to root_path
    else
      flash[:error] = "User Not Saved"
    end
  end

  def login
    user = User.find_by_email(user_params[:email])

    if user && user.authenticate(user_params[:password])
      token = encode_token({ user_id: user.id, time: Time.now })
      cookies[:auth_token] = token
      redirect_to users_path, method: :get
    else
      flash.now.alert = "Invalid email or password"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :age, :sex, :phone, :blood_type, :blood_bank_id,
                                 :password, :password_confirmation, :role_id)
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
