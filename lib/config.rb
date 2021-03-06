module Abst
	# Default precompute size of Eratosthenes sieve
	DEFAULT_SIEVE_SIZE = 1_000_000

	# System cache files will be created in this directory
	DATA_DIR = ABST_ROOT + 'data/'

	# User cache files will be created in this directory
	CACHE_DIR = ABST_ROOT + 'cache/'

	# Bit size of Fixnum
	# integer e s.t. (2 ** e) is not Fixnum and (2 ** e - 1) is Fixnum
	FIXNUM_BIT_SIZE = 30

	THREAD_NUM = defined?(JRUBY_VERSION) ? 6 : 1

	AUTO_INCLUDE = false
end
