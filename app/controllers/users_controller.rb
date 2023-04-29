class UsersController < ApplicationController
  before_action :authorize, only: [:create]
  skip_load_and_authorize_resource only: [:login, :index, :show_blood_banks]

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
        @blood_requests_to_display = @blood_requests[:pending]
      else
        @blood_bank = BloodBank.find(current_user.blood_bank_id).name
        user_data = current_user.as_json(only: [:id, :name, :email, :blood_type, :age, :sex, :phone])
      end

      if user_data
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

  def show_blood_banks
    email = params[:email]
    user = User.select(:blood_bank_id).where(email: email)
    blood_banks = BloodBank.select(:id, :name).where(id: user.pluck(:blood_bank_id))
    render json: blood_banks
  end

  def login
    user = User.find_by(email: user_params[:email], blood_bank_id: params[:blood_bank_id])

    if user && user.authenticate(user_params[:password])
      token = encode_token({ user_id: user.id, time: Time.now })
      cookies[:auth_token] = token
      redirect_to users_path, method: :get
    else
      flash[:error] = "Invalid email or password"
      redirect_to root_path
    end
  end

  def donations
    @donations = Donation.where(donar_id: current_user.id, blood_bank_id: current_user.blood_bank_id)
  end

  def consumptions
    @consumptions = BloodRequest.where(recipent_id: current_user.id, blood_bank_id: current_user.blood_bank_id)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :age, :sex, :phone, :blood_type, :blood_bank_id,
                                 :password, :password_confirmation, :role_id)
  end

  def get_user_data_according_to_blood_banks
    blood_bank_names = BloodBank.pluck(:id, :name).to_h
    all_blood_bank_names = blood_bank_names.values.uniq
    
    user_counts_by_blood_bank = {}
    all_blood_bank_names.each do |blood_bank_name|
      user_counts_by_blood_bank[blood_bank_name] = { admins: 0, users: 0 }
    end
    user_counts = User.group(:blood_bank_id, :role_id).count
    user_counts.each do |(blood_bank_id, role_id), count|
      blood_bank_name = blood_bank_names[blood_bank_id]
      next unless blood_bank_name # skip if blood bank not found
      if role_id == Role.find_by(name: Role::ROLE[:admin]).id
        user_counts_by_blood_bank[blood_bank_name][:admins] = count
      else
        user_counts_by_blood_bank[blood_bank_name][:users] = count
      end
    end

    user_counts_by_blood_bank
  end
end
