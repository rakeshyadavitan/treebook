require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  	test 'that status require content' do
  		status= Status.new
  		assert !status.save
  		assert !status.errors[:content].empty?
  	end


	test 'status content shuold at least 2 letters' do
		status = Status.new
		status.content = "H"
		assert !status.save
		assert !status.errors[:content].empty?
	end

	test 'status has a userid' do
		status = Status.new
		status.content = "hello"
		assert !status.save
		assert !status.errors[:user_id].empty?

	end



end
