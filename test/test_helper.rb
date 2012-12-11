# -*- encoding : utf-8 -*-
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def login(user = nil)
    user ||= FactoryGirl.create(:user, allow_login: true)
    @user = user
    @controller.send :login_user, @user
  end

  def login_admin(user = nil)
    user ||= FactoryGirl.create(:user, allow_login: true, super_admin: true)
    @user = user
    @controller.send :login_user, @user
  end

  def logout
    @controller.send :logout_user
  end
end
