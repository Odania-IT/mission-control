class BackupBase
	def transfer_path(path, target_folder, backup_server)
		klass = "BackupType#{backup_server.backup_type.to_s.camelcase}".constantize
		transfer_class = klass.new
		transfer_class.perform(path, target_folder, backup_server)
	end
end
