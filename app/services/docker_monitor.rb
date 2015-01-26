class DockerMonitor
	def initialize(options)
		@queue = TorqueBox::Messaging::Queue.new(options['queue_name'])
	end

	def start
		puts '******** Starting DockerMonitor ********'
		Thread.new do
			until @done
				Docker::Event.stream do |event|
					puts "Event reeived!!!!!!!"
					puts "Yes an event: #{event.inspect}"
					@queue.publish(event)
				end
			end
		end
	end

	def stop
		@done = true
	end
end
