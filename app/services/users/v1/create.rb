module Users::V1
  class Create
    def initialize(user_params, admin_user)
      @admin_user = admin_user
      @new_user_params = user_params
    end

    def call
      user = User.new(@new_user_params, blood_bank_id: @admin_user.blood_bank_id)
      if user.save
        return { message: 'User created successfully', status: 201 }
      else
        { error_message: user.errors.full_messages.join(', '), status: 422 }
      end
    end
  end
end