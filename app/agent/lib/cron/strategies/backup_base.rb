class BackupBase
	def transfer_path(path, backup_server)
		klass = "BackupType#{backup_server.backup_type.to_s.camelcase}".constantize
		transfer_class = klass.new
		transfer_class.perform(path, backup_server)
	end
end
