require 'net/ftp'

class BackupTypeFtp
	def perform(path, target_folder, backup_server)
		$LOGGER.debug "Backing up #{path} to server #{backup_server.name}"

		begin
			Net::FTP.open(backup_server.url, backup_server.user, backup_server.password) do |ftp|
				goto_and_mkdir(ftp, "#{target_folder}/#{Time.now.strftime('%Y-%m-%d_%H_%M')}")

				upload_files(ftp, path)
			end

			$LOGGER.debug "Finished backing up #{path} to server #{backup_server.name}"
		rescue => e
			$LOGGER.error 'Transfer backup failed'
			$LOGGER.error e
			ApplicationLog.error(:backup, "Transfer of backup failed to #{backup_server.name}")
		end
	end

	private

	def goto_and_mkdir(ftp, path)
		path.split('/').each do |dir_name|
			ftp.mkdir(dir_name) unless ftp.nlst.include? dir_name
			ftp.chdir(dir_name)
		end
	end

	def upload_files(ftp, source_path)
		Dir.glob("#{source_path}/*").each do |x|
			if File.directory? x
				directory = File.basename(x)
				ftp.mkdir(directory) unless ftp.nlst.include? directory
				ftp.chdir(directory)
				upload_files(ftp, x)
				ftp.chdir('..')
			elsif File.file? x
				upload_file = File.open(x, 'r')
				ftp.putbinaryfile(upload_file)
			end
		end
	end
end
