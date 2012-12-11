# -*- encoding : utf-8 -*-
require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "should get login" do
    get :login
    assert_template :login
    assert_response :success
  end

  test "#login_auth 登录成功应该跳转到首页" do
    user = FactoryGirl.create(:user, allow_login: true)
    post :login_auth, name: user.name, password: 'hncsdn_pwd'
    assert_redirected_to root_path
  end

  test "#login_auth 登录失败应该显示登录页" do
    user = FactoryGirl.create(:user, allow_login: true)
    post :login_auth, name: user.name, password: 'bad'
    assert_redirected_to action: :login
  end

=begin
  test "should get logout" do
    get :logout
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end
=end

end
