# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  has_secure_password
  validates :name, presence: true
  validates :name, uniqueness: true

  def self.new_user(user_params)
    user = User.new(user_params)
    user.password_confirmation = user.password
    user.save!
    user
  end

  def self.authenticate_user(p_name, p_passport)
    User.find_by_name(p_name).try(:authenticate, p_passport)
  end
end
