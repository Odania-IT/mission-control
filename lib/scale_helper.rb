module ScaleHelper
	class << self
		def add_application_on_server(server, application)
			application.images.each do |image|
				container = application.containers.where(image: image, server: server).first
				if container.nil? # only if there is not already an container
					container_cnt = Container.where(image: image, application: application, :status.ne => :destroy).count

					# Add container to server. Wanted instances is 1 if this image is scalable or none exists
					container = application.containers.build
					container.image = image
					container.server = server
					container.wanted_instances = (image.scalable or container_cnt == 0) ? 1 : 0
					container.scalable = image.scalable
					container.status = :down
					container.save!

					sanity_check(image)
				elsif :destroy.eql? container.status
					container.status = :down
					container.save!
				end
			end
		end

		def remove_application_on_server(server, application)
			Container.where(server: server, application: application).each do |container|
				container.status = :destroy
				container.save!

				# Check if we have enough running not scalable
				image = container.image
				if not image.scalable
					container = Container.where(application: application, image: image, :status.ne => :destroy, :server.ne => server).first

					throw Exception.new('Why is the wanted instances not zero?') unless container.wanted_instances.eql? 0

					container.wanted_instances = 1
					container.save!
				end
			end
		end

		# Make sure we do not get into any race condition. And try to clean that up.
		def sanity_check(image)
			return if image.scalable

			if Container.where(image: image, :status.ne => :destroy).sum(:wanted_instances) > 1
				logger.error 'Warning: More instances from a not scalable type should be running!'
				Container.where(image: image, :wanted_instances.gt => 1, :status.ne => :destroy).order([:created_at, :desc]).update_all(status: :destroy)
			end
		end
	end
end
