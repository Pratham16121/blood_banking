module Users::V1
  class Index
    def initialize(user)
      @user = user
    end
    
    def call
      { user_data: { user: @user
                    },
        status: 200 }
    end
  end
end