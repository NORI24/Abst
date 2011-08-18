#
# Cache
#

class CacheAccessError < Exception; end

# precompute primes by eratosthenes
def precompute_primes
	primes = eratosthenes_sieve(PRIME_CACHE_LIMIT).to_a

	Dir::mkdir(DATA_DIR) unless FileTest.exist?(DATA_DIR)
	open(PRIMES_LIST, "w") {|io| io.write(primes.map {|p| p.to_s}.join("\n"))}

	return primes
end

def load_precomputed_primes
	open(PRIMES_LIST) {|io| return io.read.split("\n").map {|line| line.to_i}}
end

$primes = nil
def primes_list
	return $primes if $primes

	# precomputed?
	if FileTest.exist?(PRIMES_LIST)
		$primes = load_precomputed_primes
	else
		$primes = precompute_primes
	end

	# set read only
	def $primes.[]=(index, value)
		raise CacheAccessError, "Primes cache is Read Only"
	end

	def $primes.include?(n)
		return Bisect.index(self, n)
	end

	return $primes
end

#
# primality test
#

# Param::  positive integer n
# Return:: a proper divisor of n if found out else nil
def trial_division(n, limit = nil)
	return nil if n <= 3
	return 2 if n.even?

	limit = isqrt(n) unless limit
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

	limit = isqrt(n)
	(2..limit).each_prime do |d|
		break if limit < d

		count = 0
		while n % d == 0
			n /= d
			count += 1
		end

		if 1 <= count
			rslt.push([d, count])
			break if 1 == n
			limit = isqrt(n)
		end
	end

	rslt.push([n, 1]) if 1 < n
	return rslt
end

#
# generation
#

def eratosthenes_sieve(n)
	return Enumerator.new(self, :eratosthenes_sieve, n) unless block_given?

	return if n < 2

	yield(2)
	return if 2 == n

	yield 3

	# make list for sieve
	sieve_len_max = (n + 1) / 2
	sieve = [true, false, true]
	sieve_len = 3
	k = 5
	i = 2
	while sieve_len < sieve_len_max
		if sieve[i]
			yield k
			sieve_len *= k
			if sieve_len_max < sieve_len
				sieve_len /= k
				# adjust sieve list length
				sieve *= sieve_len_max / sieve_len
				sieve += sieve[0...(sieve_len_max - sieve.size)]
				sieve_len = sieve_len_max
			else
				sieve = sieve * k
			end

			i.step(sieve_len, k) do |j|
				sieve[j] = false
			end
		end

		k += 2
		i += 1
	end

	# sieve
	limit = isqrt(n)
	while k <= limit
		if sieve[i]
			yield k
			j = (k ** 2 - 1) >> 1
			while j < sieve_len_max
				sieve[j] = false
				j += k
			end
		end

		k += 2
		i += 1
	end

	# output result
	limit = (n - 1) >> 1
	while i <= limit
		yield(2 * i + 1) if sieve[i]
		i += 1
	end
end

# Param::  integer n
# Return:: The least prime greater than n
def next_prime(n)
	return 2 if n < 2

	n += 1 + n[0]
	n += 2 until prime?(n)

	return n
end

class Range
	def each_prime()
		return Enumerator.new(self, :each_prime) unless block_given?

		primes = primes_list

		max = last + (exclude_end? ? -1 : 0)
		if (first <= primes.last)
			a = 0
			b = primes.size - 1
			while a < b
				t = (a + b) >> 1

				if first < primes[t]
					b = t
				elsif first == primes[t]
					a = t
					break
				else
					a = t + 1
				end
			end

			(a..(primes.size - 1)).each do |i|
				return if max < primes[i]
				yield(primes[i])
			end
		end

		s = primes.last
		s += 1 + s[0]
		s.step(max, 2) do |i|
			yield(i) if prime?(i)
		end
	end
end
