ABST_ROOT = File.dirname(__FILE__) + '/'

require_relative 'compatibility'

# Integer block byte size
BASE_BYTE = 1.size
INFINITY = Float::INFINITY

require_relative 'config'

require_relative 'bisect'
require_relative 'cache'

require_relative 'array'
require_relative 'combination'
require_relative 'complex'
require_relative 'float'
require_relative 'fundamental'
require_relative 'integer'
require_relative 'polynomial'
require_relative 'prime'
require_relative 'prime_mpqs'
require_relative 'rational'
require_relative 'sequence'
require_relative 'set'
require_relative 'vector'
require_relative 'matrix'
