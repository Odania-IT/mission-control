class WheneverScheduleGenerator
	attr_accessor :server

	def initialize(server)
		self.server = server
	end

	def generate
		template = []
		template << header
		template = template + generate_schedules
		new_schedule = template.join("\n") + "\n"

		current_schedule = File.read('/etc/nginx/sites-enabled/default.conf')

		if new_schedule != current_schedule
			File.write('/srv/agent/config/schedule.rb', new_schedule)
			cmd = 'whenever --update-crontab mission_control'
			system(cmd)
		end
	end

	private

	def header
		"job_type :cron_runner, 'cd :path && ruby cron_runner.rb :task :arguments'"
	end

	def generate_schedules
		schedules = []

		# Add all schedules

		BackgroundSchedule.where(server: self.server).each do |schedule|
			schedules << ''
			schedules << "every '#{schedule.cron_times}' do"
			schedules << "\tcron_runner '#{schedule.cron_type}', arguments: '#{schedule.id.to_s}'"
			schedules << 'end'
		end

		schedules
	end
end
