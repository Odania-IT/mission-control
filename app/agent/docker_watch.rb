$SCRIPT_TYPE = 'Docker Starter'
require_relative './lib/bootstrap'

docker_event_handler = DockerEventHandler.new($SERVER)

begin
	Docker::Event.stream do |event|
		$LOGGER.debug "Event: #{event.inspect}"
		docker_event_handler.handle event
	end
rescue Docker::Error::TimeoutError
	$LOGGER.info 'Timeout'
rescue IOError
	$LOGGER.info 'IOError'
end
