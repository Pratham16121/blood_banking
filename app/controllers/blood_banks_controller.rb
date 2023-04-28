class BloodBanksController < ApplicationController
  before_action :authorize
  def create
    blood_bank = BloodBank.new(blood_bank_params)
    if !blood_bank_unique?(blood_bank) && blood_bank.save
      flash[:success] = "Blood Bank Created Successfully"
      redirect_to root_path
    else
      render json: { error_message: blood_bank.errors.full_messages.join(', ') }, status: 422
    end 
  end

  def index
    if BloodBank.all.length > 0
      render json: { data: BloodBank.all.select(:id, :name, :location, :email).order(:id) }, status: 200
    else
      render json: { success_message: 'No Blood Banks availaible at this time' }, status: 422
    end
  end

  private
  
  def blood_bank_params
    params.require(:blood_bank).permit(:name, :address, :city, :state, :country, :location, :phone, :email)
  end

  def blood_bank_unique?(blood_bank)
    BloodBank.find_by_email(blood_bank[:email])
  end
end

