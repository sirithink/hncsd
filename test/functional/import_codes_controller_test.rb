require 'test_helper'

class ImportCodesControllerTest < ActionController::TestCase
  setup do
    login_admin
  end

  test "should get new" do
    get :new
    assert_response :success
  end
end
