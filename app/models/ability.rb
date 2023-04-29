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
    can [:logout], User
  can [:create, :index, :new], BloodBank
    can [:create], Donation do |donation|
      User.find(donation[:donar_id]).blood_bank_id == @user.blood_bank_id
    end
  end
  
  def admin_abilities
    can [:create], User
    can [:index], User
    can [:logout, :search], User
    can [:update, :create, :index], BloodRequest do |request|
      User.find(request[:recipent_id]).blood_bank_id == @user.blood_bank_id
    end
    can [:new], BloodRequest
    can [:new], Donation
    can [:create], Donation do |donation|
      donar_id = donation[:donar_id]
      User.find(donar_id).blood_bank_id == @user.blood_bank_id if donar_id.present?
    end
  end

  def user_abilities
    can [:index], User
    can [:logout], User
    can [:create], Donation do |donation|
      User.find(donation[:donar_id]).blood_bank_id == @user.blood_bank_id
    end
    can [:donations, :consumptions], User
  end
end
