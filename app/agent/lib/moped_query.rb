module Moped
	class Query
		def moped_cursor
			Cursor.new(session, operation)
		end
	end
end
