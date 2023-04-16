module Users::V1
  class Login
    def initialize
      @email = email
    end

    def call
      user = User.find_by_email(@email)

      if user && user.authenticate(user_params[:password])
        render json: { token: encode_token({ user_id: user.id }), message: 'Login successful', status: 200 }
      else
        render json: { message: 'Invalid email or password', status: 401 }
      end
    end
  end
end