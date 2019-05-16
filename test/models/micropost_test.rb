require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:example)
    @micropost = Micropost.new(content: "Lorem ipsum", user: @user)
  end

  test "should be valid" do
    assert @micropost.valid?
  end
  
  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = "  "
    assert_not @micropost.valid?
  end
  
  test "content should be at most 140 chars" do
    @micropost.content = "x" * 141
    assert_not @micropost.valid?
  end
end
