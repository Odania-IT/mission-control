class Server
	include Mongoid::Document
	include Mongoid::Timestamps

	field :name, type: String
	field :hostname, type: String
	field :ip, type: String
	field :memory, type: Integer
	field :cpu, type: Integer
	field :active, type: Mongoid::Boolean
end
