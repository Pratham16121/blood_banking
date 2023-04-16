module Users::V1
  class Index
    def initialize(email)
      @user = User.find_by_email(email)
    end
    
    def call
      byebug
      { user_data: { user: @user,
                     role: @user.role.name
                    }, 
        status: 200 }
    end
  end
end