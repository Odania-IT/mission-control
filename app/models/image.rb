class Image
	include Mongoid::Document
	include Mongoid::Timestamps

	IMAGE_TYPES = [:background, :expose]

	field :name, type: String
	field :image_type, type: Symbol
	field :image, type: String
	field :volumes, type: Array, default: []
	field :ports, type: Array, default: []
	field :links, type: Array, default: []
	field :environment, type: Array, default: []
	field :scalable, type: Mongoid::Boolean, default: false

	belongs_to :application
	has_many :containers

	validates_length_of :name, minimum: 2
	validates_length_of :image, minimum: 4
	validate :validate_image_type

	def validate_image_type
		unless IMAGE_TYPES.include? self.image_type
			errors.add(:image_type, 'invalid image type')
		end
	end

	def get_proxy_ports
		proxy_ports = []
		self.ports.each do |port|
			splitted = port.split(':')

			if splitted.length == 1
				proxy_ports << splitted[0]
			elsif splitted.length == 2
				proxy_ports << splitted[1]
			end
		end
	end

	def get_create_params(container_names)
		{Env: self.environment, Image: self.image, 'name' => self.get_name(container_names)}
	end

	def get_start_params(server)
		{Binds: prepare_volumes(server), PortBindings: self.get_port_bindings, Links: get_links(server)}
	end

	def get_port_bindings
		bindings = {}
		self.ports.each do |port|
			splitted = port.split(':')

			if splitted.length == 1
				bindings[get_port_proto(splitted[0])] = []
			elsif splitted.length == 2
				bindings[get_port_proto(splitted[1])] = [{HostPort: splitted[0]}]
			elsif splitted.length == 3
				if splitted[1].empty?
					bindings[get_port_proto(splitted[2])] = [{HostIp: splitted[0]}]
				else
					bindings[get_port_proto(splitted[2])] = [{HostPort: splitted[1], HostIp: splitted[0]}]
				end
			end
		end

		bindings
	end

	def get_port_proto(port)
		return port if port.include?('tcp') or port.include?('udp')

		"#{port}/tcp"
	end

	def get_name(container_names)
		name_base = "mc_#{self.application.name.parameterize}_#{self.name.parameterize}_".downcase

		# find the next free number
		i = 1
		not_found = true
		name = ''
		while not_found
			name = name_base + i.to_s
			not_found = false unless container_names.include?("/#{name}")
			i += 1
		end

		name
	end

	def get_links(server)
		links = []

		self.links.each do |data|
			link = data.split(':')

			image = Image.where(name: link[0]).first
			container = image.containers.where(server: server).first
			server_containers = server.server_containers.where(container: container).first

			links << "#{server_containers.name}:#{link[1]}"
		end

		links
	end

	def prepare_volumes(server)
		use_volumes = []
		self.volumes.each do |volume|
			volume_data = volume.split(':')
			volume_data[0] = '/'+volume_data[0] unless volume_data[0].start_with? '/'
			volume_data[0] = server.volumes_path.nil? ? volume_data[0] : File.absolute_path(server.volumes_path+volume_data[0])
			FileUtils.mkdir_p(volume_data[0]) unless File.directory?(volume_data[0])

			use_volumes << volume_data.join(':')
		end
		use_volumes
	end

	after_save do
		self.application.servers.each do |server|
			DockerChange.check_instances(server)
		end

		true
	end
end
