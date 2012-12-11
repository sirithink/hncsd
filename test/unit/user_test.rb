# -*- encoding : utf-8 -*-
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "#authenticate_user 通过应该返回一个用户" do
    user = FactoryGirl.create(:user)

    assert_equal user, User.authenticate_user(user.name, 'hncsdn_pwd')
    assert_equal false, User.authenticate_user(user.name, 'hncsdn_pwd1')
    assert_nil User.authenticate_user(user.name+'a', 'hncsdn_pwd')
  end
end
