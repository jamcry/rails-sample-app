require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "signup form should post to signup path" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:                  "",
                                         email:                 "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_select 'form[action="/users"]'
  end

  test "invalid user should not be saved" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:                  "",
                                         email:                 "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
  end

  test "error messages should be shown for an invalid user" do
    get signup_path
    post users_path, params: { user: { name:                  "",
                                       email:                 "user@invalid",
                                       password:              "foo",
                                       password_confirmation: "bar" } }
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid user should be saved" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:                 "Example User",
                                        email:                 "test@example.com",
                                        password:              "foobar",
                                        password_confirmation: "foobar" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_select 'div.alert-success'
    assert is_logged_in?
  end
  

end
