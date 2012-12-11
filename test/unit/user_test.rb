# -*- encoding : utf-8 -*-
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "::authenticate_user 通过应该返回一个用户" do
    user = FactoryGirl.create(:user, allow_login: true)

    assert_equal user, User.authenticate_user(user.name, 'hncsdn_pwd')
    assert_equal false, User.authenticate_user(user.name, 'hncsdn_pwd1')
    assert_nil User.authenticate_user(user.name+'a', 'hncsdn_pwd')
  end

  test "::authenticate_user 不允许登录应该验证失败" do
    user = FactoryGirl.create(:user, allow_login: false)
    assert_nil User.authenticate_user(user.name, 'hncsdn_pwd')
  end

  test "::find_user 应该只返回允许登录的用户" do
    user = FactoryGirl.create(:user, allow_login: false)
    assert_nil User.find_user(user.id)

    a_user = FactoryGirl.create(:user, allow_login: true)
    f_user = User.find_user(a_user.id)
    assert f_user.is_a?(User)
    assert_equal a_user.id, f_user.id
  end
end
