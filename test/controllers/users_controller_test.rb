require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user   = users(:example)
    @user_2 = users(:example2)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit if not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update if logged in" do
    patch user_path(@user), params: { user: { name:  @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@user_2)
    get edit_user_path(@user)
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@user_2)
    patch user_path(@user), params: { user: { name:  @user.name,
                                              email: @user.email } }
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should show users index when logged in" do
    log_in_as(@user)
    get users_path
    assert_template :index
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@user_2)
    assert_not @user_2.admin?
    patch user_path(@user_2), params: { user: { admin: true } }
    assert_not @user_2.reload.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@user_2)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  test "should destroy when logged in as an admin" do
    log_in_as(@user)
    assert_difference 'User.count', -1 do
      delete user_path(@user_2)
    end
    assert_redirected_to users_url
  end

  test "should redirect following to login when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers to login when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end
