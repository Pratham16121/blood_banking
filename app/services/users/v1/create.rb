module User:V1
  class Create
    def initialize
      @user_params = user_params
    end

    def call
      user = User.new(@user_params)

      if user.save
        return { message: 'User created successfully', status: 201 }
      else
        { error_message: user.errors.full_messages.join(', '), status: 422 }
      end
    end
  end