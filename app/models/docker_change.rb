class DockerChange
	include Mongoid::Document
	include Mongoid::Timestamps

	field :update_proxy, type: Mongoid::Boolean, default: false
	field :check_instances, type: Mongoid::Boolean, default: false
	field :update_global_proxy, type: Mongoid::Boolean, default: false
	field :update_schedule, type: Mongoid::Boolean, default: false

	belongs_to :server

	def self.check_instances(server)
		DockerChange.create(server: server,check_instances: true)
	end

	def self.update_proxy(server)
		DockerChange.create(server: server, update_proxy: true)
	end

	def self.update_schedules(server)
		DockerChange.create(server: server, update_proxy: true)
	end
end
