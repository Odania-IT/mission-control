class Server
	include Mongoid::Document
	include Mongoid::Timestamps

	field :name, type: String
	field :host, type: String
	field :ip, type: String
	field :cpus, type: Integer
	field :memory, type: Integer
end

