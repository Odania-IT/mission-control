$SCRIPT_TYPE = 'Cron Runner'
require_relative './lib/bootstrap'

unless AgentHelper.module_exists?('Rails')
	puts ARGV.inspect
end