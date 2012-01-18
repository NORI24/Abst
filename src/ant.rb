require_relative 'include/compatibility'

module ANT
	ANT_ROOT = File.dirname(__FILE__) + '/'

	# Integer block byte size
	BASE_BYTE = 1.size
	INFINITY = Float::INFINITY

	I = Complex::I
end

require_relative 'ant_config'

require_relative 'include/bisect'
require_relative 'include/cache'

require_relative 'include/group'
require_relative 'include/ring'

require_relative 'include/array'
require_relative 'include/complex'
require_relative 'include/float'
require_relative 'include/fundamental'
require_relative 'include/integer'
require_relative 'include/prime'
require_relative 'include/prime_mpqs'
require_relative 'include/rational'
require_relative 'include/sequence'
require_relative 'include/set'

require_relative 'include/vector'
require_relative 'include/polynomial'
require_relative 'include/matrix'

include ANT if ANT::AUTO_INCLUDE
