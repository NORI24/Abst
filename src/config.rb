# Precompute primes under the value
PRIME_CACHE_LIMIT = 1_000_000

# System cache files will be created in this directory
DATA_DIR = ABST_ROOT + 'data/'

# User cache files will be created in this directory
CACHE_DIR = ABST_ROOT + 'cache/'

# Cache primes
PRIMES_LIST = DATA_DIR + 'primes_list'

# Bit size of Fixnum
# integer e s.t. (2 ** e) is not Fixnum and (2 ** e - 1) is Fixnum
FIXNUM_BIT_SIZE = 30
