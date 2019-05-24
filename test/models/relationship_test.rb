require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @first_user = users(:example)
    @second_user = users(:example2)
    @relationship = Relationship.new(follower_id: @first_user.id,
                                     followed_id: @second_user.id)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "follower_id should be present" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "followed_id should be present" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end

  test "example1 should be following example2" do
    @relationship.save
    assert @first_user.following.include?(@second_user)
  end
end
