class Status < ActiveRecord::Base
	attr_accessible :content, :user_id, :id, :created_at, :updated_at
	belongs_to :user
end
