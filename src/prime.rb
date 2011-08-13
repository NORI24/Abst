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

# Param::  positive integer n
# Return:: factorization of n s.t. [[a, b], [c, d], ...], n = a**b * c**d * ...
def factorize(n)
	return [[1, 1]] if 1 == n

	rslt = []

	count = 0
	while n % 2 == 0
		n >>= 1
		count += 1
	end
	rslt.push([2, count]) if 1 <= count

	limit = integer_square_root(n)
	3.step(limit, 2) do |d|
		count = 0
		while n % d == 0
			n /= d
			count += 1
		end

		if 1 <= count
			rslt.push([d, count])
			break if 1 == n
			limit = integer_square_root(n)
		end
	end

	rslt.push([n, 1]) if 1 < n
	return rslt
end

#
# generation
#

# Param::  positive integer n
# Return:: The least prime greater than n
def next_prime(n)
	return 2 if n < 2

	n += n[0] + 1

	loop do
		return n if prime?(n)

		n += 2
	end
end

class Range
	def each_prime()
		return Enumerator.new(self, :each_prime) unless block_given?

		self.each do |i|
			yield(i) if prime?(i)
		end
	end
end
