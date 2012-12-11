# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  has_secure_password
  validates :name, presence: true
  validates :name, uniqueness: true
  scope :allows, where(allow_login: true)

  def self.new_user(user_params)
    user = User.new(user_params)
    user.password_confirmation = user.password
    user.save!
    user
  end

  def self.authenticate_user(p_name, p_passport)
    User.allows.find_by_name(p_name).try(:authenticate, p_passport)
  end

  def self.find_user(user_id)
    User.allows.find_by_id(user_id)
  end
end
