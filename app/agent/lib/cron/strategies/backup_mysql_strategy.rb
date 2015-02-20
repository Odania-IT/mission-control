class BackupMysqlStrategy
	def perform(schedule, image, params)
		$LOGGER.info "Starting mysql backup for image '#{image.name}'"

		root_password = nil
		image.environment.each do |environment|
			key, value = environment.split('=')
			root_password = value if 'MYSQL_ROOT_PASSWORD'.eql? key
		end

		puts "pw: #{root_password}"

		# TODO can we get around the pw requirement through linking? Or templates for mysql, etc.?
		#database_list_command = "mysql -u %s -p%s -h %s --silent -N -e 'show databases'" % (mysql_user, mysql_pass, mysql_host)

		#dump_command = "mysqldump -u %s -p%s -h %s -e --opt -c %s | gzip -c > %s" % (mysql_user, mysql_pass, mysql_host, database, filename)
	end
end
