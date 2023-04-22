# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user.blank? ? return : (@user = user)
    super_admin_abilities if @user.is_super_admin? 
    admin_abilities if @user.is_admin?
    user_abilities if @user.is_user?
  end

  def super_admin_abilities
    can [:create], User
    can [:index], User
    can [:create, :index], BloodBank
  end
  
  def admin_abilities
    can [:create], User 
    can [:index], User
  end

  def user_abilities
  end
end
