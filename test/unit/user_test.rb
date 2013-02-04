require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "a user should enter a first name"do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:first_name].empty?
  end

  	test "a user should enter a last name"do
  	  user= User.new
	  assert !user.save
	  assert !user.errors[:last_name].empty?
	end

	test "a user should enter a profile name" do
		user = User.new
		assert !user.save
		assert !user.errors[:profile_name].empty?
	end

	test "a user should enter a unique profile name" do
		user = User.new
		user.profile_name = users(:rakesh).profile_name		
		assert !user.save		
		assert !user.errors[:profile_name].empty?
	end

	test "a user should enter a profile name without spaces" do
		user = User.new
		user.profile_name = "Profile name with spaces"
		assert !user.save
		assert !user.errors[:profile_name].empty?
		assert user.errors[:profile_name].include?('Must be formatted correctly.')
	end

	# test 'a user can have correctly formatted profile name' do
	# 		user = User.new(first_name:'rakesh', last_name:'yadav', email:'rakesh.yadav@tekacademy.com')
	# 		user.password = user.password_confirmation = '60086008'
	# 		user.profile_name = 'rakeshyadav_1'
	# 		assert user.valid?
	# end

end
