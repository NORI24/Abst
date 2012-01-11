module ANT
	# Precompute primes under the value
	PRIME_CACHE_LIMIT = 1_000_000

	# System cache files will be created in this directory
	DATA_DIR = ANT_ROOT + 'data/'

	# User cache files will be created in this directory
	CACHE_DIR = ANT_ROOT + 'cache/'

	# Cache primes
	PRIMES_LIST = DATA_DIR + 'primes_list'

	# Bit size of Fixnum
	# integer e s.t. (2 ** e) is not Fixnum and (2 ** e - 1) is Fixnum
	FIXNUM_BIT_SIZE = 30

	THREAD_NUM = defined?(JRUBY_VERSION) ? 6 : 1

	AUTO_INCLUDE = true
end
