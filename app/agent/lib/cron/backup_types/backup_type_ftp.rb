require 'net/ftp'

class BackupTypeFtp
	def perform(path, backup_server)
		$LOGGER.debug "Backing up #{path} to server #{backup_server.name}"

		Net::FTP.open(backup_server.url, backup_server.login, backup_server.password) do |ftp|
			puts ftp.ls
		end
	end
end
