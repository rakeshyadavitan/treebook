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
		assert users(:rakesh).pending_friends.include?(users(:vikas))
	end

	context 'a new instance' do
		setup do
			@user_friendship = UserFriendship.new user: users(:rakesh), friend: users(:vikas)
		end

		should 'have a pending state' do
			assert_equal 'pending', @user_friendship.state
		end
	end

	context '#send_request_email' do
		setup do
			@user_friendship = UserFriendship.create user: users(:rakesh), friend: users(:vikas)
		end

		should 'send a email' do
			assert_difference 'ActionMailer::Base.deliveries.size', 1 do
				@user_friendship.send_request_email
			end
		end
	end

	context "#mutual_friendship" do
		setup do
			UserFriendship.request users(:rakesh), users(:ravi) 
			@friendship1 = users(:rakesh).user_friendships.where(friend_id: users(:ravi).id).first
			@friendship2 = users(:ravi).user_friendships.where(friend_id: users(:rakesh).id).first
		end

		should "correctly find the mutual friendship" do
			assert_equal @friendship2, @friendship1.mutual_friendship
		end
	end

	context "#accept_mutual_friendship!" do
		
		setup do
			UserFriendship.request users(:rakesh), users(:ravi)
		end

		should "accept the mutual friendship" do 
			friendship1 = users(:rakesh).user_friendships.where(friend_id: users(:ravi).id).first
			friendship2 = users(:ravi).user_friendships.where(friend_id: users(:rakesh).id).first
			friendship1.accept_mutual_friendship!
			friendship2.reload
			assert_equal "accepted",friendship2.state
		end
	end

	context '#accepted!' do
		setup do
			@user_friendship = UserFriendship.request users(:rakesh), users(:vikas)
		end

		should 'set the state to accepted' do 
			@user_friendship.accepted!
			assert_equal "accepted", @user_friendship.state
		end

		should 'send the acceptance email' do
			assert_difference 'ActionMailer::Base.deliveries.size' , 1 do
				@user_friendship.accepted!
			end
		end

		should 'include the friend in the list of friends' do
			@user_friendship.accepted!
			users(:rakesh).friends.reload
			assert users(:rakesh).friends.include?(users(:vikas))
		end

		should "accept the mutual friendship" do
			@user_friendship.accepted!
			assert_equal "accepted", @user_friendship.mutual_friendship.state
		end

	end

	context '.request' do
		should 'create two user friendships' do
			assert_difference 'UserFriendship.count', 2 do
				UserFriendship.request(users(:rakesh), users(:vikas))
			end
		end

		should 'send a friend request email' do
			assert_difference 'ActionMailer::Base.deliveries.size', 1 do
				UserFriendship.request(users(:rakesh), users(:vikas))
			end
		end
	end

	context "#delete_mutual_friendship!" do
		
		setup do
			UserFriendship.request users(:rakesh), users(:ravi)
			@friendship1 = users(:rakesh).user_friendships.where(friend_id: users(:ravi).id).first
			@friendship2 = users(:ravi).user_friendships.where(friend_id: users(:rakesh).id).first
		end

		should "delete the mutual friendship" do
			assert_equal @friendship2, @friendship1.mutual_friendship
			@friendship1.delete_mutual_friendship!
			assert !UserFriendship.exists?(@friendship2.id)

		end
	end

	context "on destroy" do
		setup do
			UserFriendship.request users(:rakesh), users(:ravi)
			@friendship1 = users(:rakesh).user_friendships.where(friend_id: users(:ravi).id).first
			@friendship2 = users(:ravi).user_friendships.where(friend_id: users(:rakesh).id).first
		end

		should "delete the mutual friendship" do
			@friendship1.destroy
			assert !UserFriendship.exists?(@friendship2.id)
		end
	end

end
