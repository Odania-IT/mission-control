require_relative './strategies/backup_mysql_strategy'

class BackupCron
	def perform(schedule, params)
		image = schedule.image
		if image.nil?
			$LOGGER.warn "Image for schedule #{schedule.name} not found!"
			return
		end

		klass = "Backup#{schedule.strategy.to_s.camelcase}Strategy".constantize
		$LOGGER.info "Starting backup for image '#{image.name}' with strategy '#{klass}'"
		backup_class = klass.new
		backup_class.perform(schedule, image, params)
	end
end
