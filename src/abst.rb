ABST_ROOT = File.dirname(__FILE__) + '/'

# Integer block byte size
BASE_BYTE = 1.size

# extension
class Integer
	def self.one
		return 1
	end

	def self.zero
		return 0
	end

	def bit_size
		return ilog2(self) + 1
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

require ABST_ROOT + 'config'

require ABST_ROOT + 'cache'

require ABST_ROOT + 'combination'
require ABST_ROOT + 'prime'
require ABST_ROOT + 'fundamental'
require ABST_ROOT + 'matrix'
require ABST_ROOT + 'polynomial'
require ABST_ROOT + 'prime'
require ABST_ROOT + 'rational'
require ABST_ROOT + 'sequence'
require ABST_ROOT + 'vector'

require ABST_ROOT + 'pe'
