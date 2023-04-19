module Users::V1
  class Login < ApplicationController
    def initialize(params)    
      @email = params[:email]
      @password = params[:password]
    end

    def call
      user = User.find_by_email(@email)

      if user && user.authenticate(@password)
        { token: encode_token({ user_id: user.id, time: Time.now }),
          message: 'Login successful', status: 200 }.as_json
      else
        { message: 'Invalid email or password', status: 401 }.as_json
      end
    end
  end
end