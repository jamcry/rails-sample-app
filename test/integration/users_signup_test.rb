require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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
end
