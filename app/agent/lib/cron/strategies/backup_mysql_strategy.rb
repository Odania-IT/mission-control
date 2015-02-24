class BackupMysqlStrategy < BackupBase
	def perform(schedule, image, params)
		$LOGGER.info "Starting mysql backup for image '#{image.name}'"

		root_password = nil
		if image.template_environment['MYSQL_ROOT_PASSWORD']
			root_password = image.template_environment['MYSQL_ROOT_PASSWORD']
		else
			image.environment.each do |environment|
				key, value = environment.split('=')
				root_password = value if 'MYSQL_ROOT_PASSWORD'.eql? key
			end
		end

		container = image.containers.where(server: schedule.server).first
		if container.nil?
			$LOGGER.error "No container found for image #{image.name}! Backup failed!"
			return
		end

		server = schedule.server
		server_container = server.server_containers.where(container: container).first
		if server_container.nil?
			$LOGGER.error "No container found for image #{image.name}! Backup failed!"
			container.application_errors << "[#{Time.now}] No container found for image #{image.name}! Backup failed!"
			container.save!
			return
		end

		backup_path = File.absolute_path(server.backup_path) + '/strategy-mysql'
		FileUtils.mkdir_p(backup_path)

		# Get all databases
		cmd = "mysql -u root -p%s -h %s --silent -N -e 'show databases'" % [root_password, server_container.ip]
		databases = `#{cmd}`

		databases.split("\n").each do |database|
			next if %w(information_schema performance_schema).include?(database)

			filename = '%s/%s.mysql.sql.gz' % [backup_path, database]
			cmd = 'mysqldump -u root -p%s -h %s -e --opt -c %s | gzip -c > %s' % [root_password, server_container.ip, database, filename]
			system(cmd)
		end

		transfer_path(backup_path, schedule.backup_server)
	end
end
