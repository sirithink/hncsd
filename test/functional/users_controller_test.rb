# -*- encoding : utf-8 -*-
require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    login
  end

  #TODO
  test "users应该只允许管理员访问" do
    get :index
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
