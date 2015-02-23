$SCRIPT_TYPE = 'Cron Runner'
require_relative './lib/bootstrap'

unless AgentHelper.module_exists?('Rails')
	require_relative './lib/cron/backup_cron'

	klass = (ARGV.shift.camelcase+'Cron').constantize
	schedule = BackgroundSchedule.where(_id: ARGV.shift).first

	cron_class = klass.new
	cron_class.perform(schedule, ARGV)
end
