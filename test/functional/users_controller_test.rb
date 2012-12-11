# -*- encoding : utf-8 -*-
require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    login_admin
  end

  test "没有登录访问应该重定向到登录页" do
    logout
    get :index
    assert_redirected_to login_path
    assert_equal '用户过期或没有登录,请先登录', flash.alert
  end

  test "非管理员访问应该重定向到首页" do
    logout
    login
    get :index
    assert_redirected_to root_path
    assert_equal '没有操作权限', flash.alert
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
