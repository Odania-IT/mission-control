class DockerEventProcessor < TorqueBox::Messaging::MessageProcessor
	def on_message(message)
		puts "Msg: #{message}"
	end
end
