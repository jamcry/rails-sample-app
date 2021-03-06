require 'test_helper'

class UserTest < ActiveSupport::TestCase
	def setup
		@user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
	end

	test "should be valid" do
		assert @user.valid?
	end

	test "name should be present" do
		@user.name = "   "
		assert_not @user.valid?
	end

	test "email should be present" do
		@user.email = "   "
		assert_not @user.valid?
	end

	test "name should not be too long" do
		@user.name = "x" * 51
		assert_not @user.valid?
	end

	test "email should not be too long" do
		@user.email = "a" * 244 + "@example.com"
		assert_not @user.valid?
	end

	test "email should be in valid format" do
		valid_addresses = %w[user@example.com USER@foo.com A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
		valid_addresses.each do |valid_address|
			@user.email = valid_address
			assert @user.valid?, "#{valid_address.inspect} should be valid"
		end
	end

	test "email validation should reject invalid addresses" do
		invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
		invalid_addresses.each do |invalid_address|
			@user.email = invalid_address
			assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
		end
	end

	test "email addresses should be unique" do
		duplicate_user = @user.dup
		duplicate_user.email = @user.email.upcase
		@user.save
		assert_not duplicate_user.valid?
	end

	test "email addresses should be saved in lower-case" do
		mixed_case_email = "Foo@eXAmpLe.Com"
		@user.email = mixed_case_email
		@user.save
		assert_equal @user.reload.email, mixed_case_email.downcase
	end

	test "password should be present (nonblank)" do
		@user.password = @user.password_confirmation = " " * 6
		assert_not @user.valid?
	end
	
	test "password should have a min length" do
		@user.password = @user.password_confirmation = "a" * 5
		assert_not @user.valid?
	end

	test "#authenticated? should return false for a user with nil digest" do
		assert_not @user.authenticated?(:remember, '')
	end

	test "associated posts should be destroyed with user" do
		@user.save
		@user.microposts.create!(content: "Lorem ipsum")
		assert_difference 'Micropost.count', -1 do
			@user.destroy
		end
	end

	test "should follow and unfollow a user" do
		first_user = users(:example)
		second_user = users(:example4)
		assert_not first_user.following?(second_user)
		first_user.follow(second_user)
		assert first_user.following?(second_user)
		assert second_user.followers.include?(first_user)
		first_user.unfollow(second_user)
		assert_not first_user.following?(second_user)
	end

	test "feed should show the right posts" do
		user1 = users(:example)	
		user2 = users(:example2)
		user3 = users(:example4)
    assert user1.following.include? user2
    assert_not user1.following.include? user3
    # Posts from followed user
    user2.microposts.each do |post_following|
      assert user1.feed.include?(post_following)
    end

    # Posts from self
    user1.microposts.each do |post_self|
      assert user1.feed.include?(post_self)
    end

    # Posts from unfollowed user
    user3.microposts.each do |post_unfolllowed|
      assert_not user1.feed.include?(post_unfolllowed)
    end
	end
end
