require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end


  should belong_to (:user)
  should belong_to(:friend)


	test 'that crating a friendship works without raising an exception' do
		assert_nothing_raised do
			UserFriendship.create user: users(:rakesh) , friend: users(:vikas)
		end
	end

	test 'that creating a friendships based on userid and friend id works' do
		UserFriendship.create user_id: users(:rakesh).id, friend_id: users(:vikas).id
		assert users(:rakesh).friends.include?(users(:vikas))
	end


end
