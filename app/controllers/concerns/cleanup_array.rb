module CleanupArray
	extend ActiveSupport::Concern

	included do
		def do_cleanup_array(obj, params_obj, fields)
			fields.each do |field|
				obj[field] = [] if params_obj[field].nil?
			end
		end
	end
end
