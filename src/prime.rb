#
# primality test
#

# Param::  positive integer n
# Return:: a proper divisor of n if found out else nil
def trial_division(n, limit = nil)
	return nil if n <= 3
	return 2 if n[0] == 0

	limit = integer_square_root(n) unless limit
	3.step(limit, 2) do |d|
		return d if n % d == 0
	end

	return nil
end

# Param::  positive integer n
# Return:: boolean whether n is prime or not
def prime?(n)
	if n <= 3
		return false if n <= 1
		return true
	end

	return (not trial_division(n))
end

#
# factorization
#

def factorization(n)
	raise NotImplementedError
end

#
# generation
#

def next_prime(n)
	raise NotImplementedError
end

class Range
	def each_prime(n)
		raise NotImplementedError
	end
end
