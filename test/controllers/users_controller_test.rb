require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get signup" do
    get :new
    assert_response :success
    assert_select "title", "Sign up | Twitter Clone"
  end

end
