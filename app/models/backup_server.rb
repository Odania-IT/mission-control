class BackupServer
	include Mongoid::Document
	include Mongoid::Timestamps

	field :name, type: String
	field :url, type: String
	field :user, type: String
	field :password, type: String

	validates_uniqueness_of :name
	validates_length_of :name, minimum: 2
	validates_length_of :url, minimum: 5
	validates_length_of :user, minimum: 1
	validates_length_of :password, minimum: 1
end
