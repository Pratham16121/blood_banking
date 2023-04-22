class Api::V1::BloodBanksController < ApplicationController
  before_action :authorize
  def create
    blood_bank = BloodBank.new(blood_bank_params)
    if !blood_bank_unique?(blood_bank) && blood_bank.save
      render json: { success_message: 'Blood Bank created successfully!' }, status: 200
    else
      render json: { error_message: 'Could not create Blood Bank' }, status: 401
    end 
  end

  def index
    if BloodBank.all.length > 0
      render json: { data: BloodBank.all }, status: 200
    else
      render json: { success_message: 'No Blood Banks availaible at this time' }, status: 404
    end
  end

  private
  
  def blood_bank_params
    params.require(:blood_bank_data).permit(:name, :address, :city, :state, :country, :location, :phone, :email)
  end

  def blood_bank_unique?(blood_bank)
    BloodBank.find_by_email(blood_bank[:email])
  end
end
