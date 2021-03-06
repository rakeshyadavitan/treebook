require 'test_helper'

class CustomRoutesTest < ActionDispatch::IntegrationTest
  
	test 'that/login route opens the login page' do
		get '/login'
		assert_response :success		
	end

	test 'that/logout routes opens the log out page' do
		get '/logout'
		assert_response :redirect
		assert_redirected_to '/'
	end

	test 'that/register routes opens the sign up page' do
		get '/register'
		assert_response :success
	end

	test 'that profile page works' do
		get '/rakeshinvalid'
		assert_response :success
	end


end
