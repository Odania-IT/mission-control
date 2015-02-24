class BackupServer
	include Mongoid::Document
	include Mongoid::Timestamps

	BACKUP_TYPES = [:ftp] # TODO add :ssh, :duplicity_ftp, :duplicity_scp

	field :name, type: String
	field :backup_type, type: Symbol
	field :url, type: String
	field :user, type: String
	field :password, type: String

	validates_uniqueness_of :name
	validates_length_of :name, minimum: 2
	validates_length_of :url, minimum: 5
	validates_length_of :user, minimum: 1
	validates_length_of :password, minimum: 1
	validate :validate_backup_type

	def validate_backup_type
		unless BACKUP_TYPES.include? self.backup_type
			errors.add(:backup_type, 'invalid backup type')
		end
	end
end
