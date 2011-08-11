path = File.dirname(__FILE__) + '/'

# extension
class Integer
	def self.one
		return 1
	end

	def self.zero
		return 0
	end
end

class Float
	def self.one
		return 1.0
	end

	def self.zero
		return 0.0
	end

	def inverse
		return 1.0 / self
	end
end

require path + 'config'

require path + 'prime'
require path + 'fundamental'
require path + 'matrix'
require path + 'polynomial'
require path + 'prime'
require path + 'vector'
