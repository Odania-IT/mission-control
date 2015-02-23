$SCRIPT_TYPE = 'Generate Schedule'
require_relative './lib/bootstrap'

unless AgentHelper.module_exists?('Rails')
	whenever_schedule_generator = WheneverScheduleGenerator.new($SERVER)
	whenever_schedule_generator.generate
end
