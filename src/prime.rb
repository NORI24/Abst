#
# Cache
#

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

	def $primes.include?(n)
		return Bisect.index(self, n)
	end

	$primes.freeze

	return $primes
end

#
# primality test
#

# Param::  positive integer n
#          positive integer base
# Return:: boolean whether n passes a pseudoprime test or not
#          When n and base are not relatively prime, this algorithm
#          may judge a prime number n to be a composite number
def pseudoprime_test(n, base)
	return power(base, n - 1, n) == 1
end

# Param::  positive odd integer n
#          positive integer b
#          integer e and k s.t. n = 2 ** e * k and k is odd.
# Return:: boolean whether n passes a strong pseudoprime test for the base b or not
#          When n and b are not relatively prime, this algorithm
#          may judge a prime number n to be a composite number
def strong_pseudoprime_test(n, b, e = nil, k = nil)
	n_minus_1 = n - 1

	unless e
		e = 0
		e += 1 while 0 == n_minus_1[e]
		k = n_minus_1 >> e
	end

	z = power(b, k, n)

	return true if 1 == z or n_minus_1 == z
	(e - 1).times do
		z = z ** 2 % n
		return true if z == n_minus_1
	end

	return false
end

# Miller-Rabin pseudo-primality test
# Param::  odd integer n >= 3
# Return:: boolean whether n passes trials times random base strong pseudoprime test or not
#          integer witness (or nil) if return_witness
def miller_rabin(n, trials = 20, return_witness = false)
	# Precomputation
	n_minus_1 = n - 1
	e = 0
	e += 1 while 0 == n_minus_1[e]
	k = n_minus_1 >> e

	trials.times do
		base = rand(n - 2) + 2
		unless strong_pseudoprime_test(n, base, e, k)
			return return_witness ? [false, base] : false
		end
	end

	return return_witness ? [true, nil] : true
end

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

	return false unless miller_rabin(n)

	return (not trial_division(n))
end

#
# factorization
#

# Param::  positive integer n
#          positive integer bound <= PRIME_CACHE_LIMIT
#          positive integer m (2 <= m < n)
# Return:: a factor f (1 < f < n) if found else nil
def p_minus_1(n, bound = 10_000, m = 2)
	plist = primes_list

	p = nil
	old_m = m
	old_i = i = -1
	loop do
		i += 1
		p = plist[i]
		break if nil == p or bound < p

		# Compute power
		p_pow = p
		lim = bound / p
		p_pow *= p while p_pow <= lim
		m = power(m, p_pow, n)

		next unless 15 == i & 15

		# Compute GCD
		g = binary_gcd(m - 1, n)
		if 1 == g
			old_m = m
			old_i = i
			next
		end
		return g unless n == g
		break
	end

	if nil == p or bound < p
		return nil if 0 == i & 15

		g = binary_gcd(m - 1, n)
		return nil if 1 == g
		return g unless n == g
	end

	# Backtrack
	i = old_i
	m = old_m

	loop do
		i += 1
		p_pow = p = plist[i]

		loop do
			m = power(m, p, n)
			g = binary_gcd(m - 1, n)
			if 1 == g
				p_pow *= p
				break if bound < p_pow
				next
			end
			return nil if n == g
			return g unless 1 == g
		end
	end
end

# Param::  positive integer n
# Return:: factorization of n s.t. [[a, b], [c, d], ...], n = a**b * c**d * ...
def factorize(n)
	return [[1, 1]] if 1 == n

	rslt = []

	limit = isqrt(n)
	(2..limit).each_prime do |d|
		break if limit < d
		next unless 0 == n % d

		n /= d
		div_count = 1
		loop do
			q, r = n.divmod(d)
			break unless 0 == r

			n = q
			div_count += 1
		end

		rslt.push([d, div_count])
		limit = isqrt(n)
		break if limit <= d
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

	n += (n.even? ? 1 : 2)
	n += 2 until prime?(n)

	return n
end

class Range
	def each_prime()
		return Enumerator.new(self, :each_prime) unless block_given?

		primes = primes_list

		max = last + (exclude_end? ? -1 : 0)
		if (first <= primes.last)
			a = Bisect.bisect_left(primes, first)
			(a...primes.size).each do |i|
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

def phi(n)
	return 1 if 1 == n
	return n - 1 if prime?(n)

	return factorize(n).inject(1) {|r, i| r * i[0] ** (i[1] - 1) * (i[0] - 1)}
end
