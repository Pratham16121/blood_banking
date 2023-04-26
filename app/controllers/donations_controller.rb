class DonationsController < ApplicationController
  before_action :authorize

  def create    
    donation = Donation.new(donation_params)
    donation.blood_bank_id = current_user.blood_bank_id
    donation.donation_date = Time.current
    if donation.save
      render json: { success_message: 'Donated successfully' }
    else
      render json: { error_message: donation.errors.full_messages.join(',') }, status: 422
    end
  end

  private

  def donation_params
    params.require(:donation).permit(:donar_id, :blood_type, :blood_unit)
  end
end

