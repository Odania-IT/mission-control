require 'net/ftp'

class BackupTypeFtp
	def perform(path, backup_server)
		$LOGGER.debug "Backing up #{path} to server #{backup_server.name}"

		begin
			Net::FTP.open(backup_server.url, backup_server.user, backup_server.password) do |ftp|
				puts ftp.ls
			end
		rescue => e
			$LOGGER.error 'Transfer backup failed'
			$LOGGER.error e
			ApplicationLog.error(:backup, "Transfer of backup failed to #{backup_server.name}")
		end
	end
end
