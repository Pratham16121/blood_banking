class Api::V1::BloodRequestsController < ApplicationController
  before_action :authorize
  def index
    blood_requests = BloodRequest.where(blood_bank_id: current_user.id).group(:is_completed)
    if blood_requests
      render json: { blood_request_data: blood_requests }, status: 200
    else
      render json: { error_message: "Something went wrong" }
    end
  end

  def create
    blood_request = BloodRequests.new(blood_request_params)
    if blood_request.save
      render json: { success_message: "Blood Request Saved" }, status: 200
    else
      render json: { error_message: blood_request.errors.full_messages.join(', ') }, status: 401
    end
  end

  def update
    blood_request = BloodRequests.find params[:id]
    if blood_request.update!(blood_request_params)
      render json: { success_message: "Blood Request Updated" }, status: 200
    else
      render json: { error_message: blood_request.errors.full_messages.join(', ') }, status: 401
    end
  end

  private

  def blood_request_params
    params.require(blood_request_data).permit(:recipent_id, :blood_type, :is_completed)
  end
end
