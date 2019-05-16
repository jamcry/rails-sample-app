require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:example)
  end

  test "profile display" do  
    # visit user profile
    get user_path(@user)
    assert_template 'users/show' 
    # check page title
    assert_select 'title', full_title(@user.name)
    # check user's name
    assert_select 'h1', text: @user.name
    # check gravatar
    assert_select 'h1>img.gravatar'
    # check micropost count appears on the page
    assert_match @user.microposts.count.to_s, response.body
    # check pagination of microposts
    assert_select 'div.pagination', 1
    @user.microposts.paginate(page: 1).each do |post|
      # check all the posts in first pagination appears
      assert_match post.content, response.body
    end
  end
end
