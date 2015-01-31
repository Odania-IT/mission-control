class DockerChange
	include Mongoid::Document
	include Mongoid::Timestamps

	field :update_proxy, type: Mongoid::Boolean, default: false
end
