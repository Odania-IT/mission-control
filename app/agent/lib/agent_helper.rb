module AgentHelper
	class << self
		def module_exists?(class_name)
			klass = Module.const_get(class_name)
			return klass.is_a?(Module)
		rescue NameError
			return false
		end
	end
end
