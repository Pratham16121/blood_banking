class BloodRequestsController < ApplicationController
  before_action :authorize

  def new
  end

  def index
    blood_requests = BloodRequest.where(blood_bank_id: current_user.blood_bank_id)
                             .group_by(&:is_completed?)
    blood_requests = { pending: blood_requests[false] || [],
                      completed: blood_requests[true] || [] }

    if blood_requests
      render json: { blood_request_data: blood_requests }, status: 200
    else
      render json: { error_message: "Something went wrong" }
    end
  end

  def create
    blood_request = BloodRequest.new(blood_request_params)
    blood_request.blood_bank_id = current_user.blood_bank_id
    if blood_request.save
      flash[:success] = "Blood Request Saved"
      redirect_to root_path
    else
      render json: { error_message: blood_request.errors.full_messages.join(', ') }, status: 401
    end
  end

  def update
    # Find total count of blood bags with a particular blood type and current_user blood bank id
    blood_request = BloodRequest.find(params[:id])
    blood_type = blood_request.blood_type
    blood_bank_id = current_user.blood_bank_id
    blood_bags = BloodBag.where(blood_type: blood_type, blood_bank_id: blood_bank_id)

    # Calculate the total count of blood bags
    total_count = blood_bags.sum(:quantity)

    # Check if total count is greater than or equal to twice the requested blood units
    if total_count >= blood_request.blood_unit * 2
      # Sort blood bags by their latest expiry date
      blood_bags = blood_bags.order(:expiry_date)

      # Subtract the quantity of blood_request.blood_unit * 2 from the blood bags according to their latest dates of expiry
      blood_bags_left_to_remove = blood_request.blood_unit * 2
      blood_bags.each do |blood_bag|
        break if blood_bags_left_to_remove == 0

        quantity_to_remove = [blood_bags_left_to_remove, blood_bag.quantity].min
        blood_bag.update(quantity: blood_bag.quantity - quantity_to_remove)

        blood_bags_left_to_remove -= quantity_to_remove
      end

      blood_request.update!(blood_request_params)
      flash[:success] = "Your Blood Request has been processed!"
      redirect_to root_path, status: :see_other

    else
      flash[:error] = "Your blood request can't be processed at this time!"
      redirect_to root_path
      # render json: { error_message: blood_request.errors.full_messages.join(', ') }, status: 422
    end
  end

  private

  def blood_request_params
    params.require(:blood_request).permit(:recipent_id, :blood_type, :is_completed, :blood_unit)
  end
end
