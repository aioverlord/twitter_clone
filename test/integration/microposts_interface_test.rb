require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    # Log in
    log_in_as(@user)
    get root_path
    # Check micropost pagination
    assert_select 'div.pagination'
    # Make invalid new micropost submission
    assert_no_difference 'Micropost.count' do 
      post microposts_path, micropost: { content: " " }
    end
    assert_select 'div#error_explanation'
    # assert_not flash.empty?
    # Make valid new micropost submission
    content = "Blah blah blah"
    assert_difference 'Micropost.count', 1 do 
      post microposts_path, micropost: { content: content }
    end
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    # Check if content is displayed on the page
    assert_match content, response.body
    # Delete a micropost
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do 
      delete micropost_path(first_micropost)
    end
    assert_not flash.empty?
    # Visit other users's page
    get user_path(users(:archer))
    # Ensure there are no delete links
    assert_select 'a', text: "delete", count: 0
  end
end
