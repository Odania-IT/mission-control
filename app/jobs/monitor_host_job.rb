class MonitorHostJob
	def run
		host = `hostname`.strip
		puts host
	end

	def on_error(exception)
		# Optionally implement this method to interrogate any exceptions
		# raised inside the job's run method.
	end

	def on_timeout

	end
end
