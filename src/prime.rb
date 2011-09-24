#
# Cache
#

# precompute primes by eratosthenes
def precompute_primes
	primes = eratosthenes_sieve(PRIME_CACHE_LIMIT).to_a

	Dir::mkdir(DATA_DIR) unless FileTest.exist?(DATA_DIR)
	open(PRIMES_LIST, "w") {|io| io.write(primes.map(&:to_s).join("\n"))}

	return primes
end

def load_precomputed_primes
	open(PRIMES_LIST) {|io| return io.read.split("\n").map(&:to_i)}
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
# Return:: boolean whether n is prime or not
def prime?(n)
	if n <= 3
		return false if n <= 1
		return true
	end

	factor = trial_division(n, 257)[0]
	return factor[0][0] == n unless factor.empty?

	if n < 341_550_071_728_321
		[2, 3, 5, 7, 11, 13, 17].each do |i|
			return false unless strong_pseudoprime_test(n, i)
		end
		return true
	end

	return false unless miller_rabin(n)
	return n == trial_division(n)[0][0][0]
end

#
# factorization
#

# Param::  positive integer n >= 2
#          positive integer limit
# Return:: factorization up to limit and remainder of n i.e.
#          [[[a, b], [c, d], ...], r] s.t.
#          n == a**b * c**d * ... * r, (r have no factor less than or equal to limit ** 2)
def trial_division(n, limit = INFINITY)
	factor = []
	lim = [limit, isqrt(n)].min

	divide = Proc.new do |d|
		n /= d
		div_count = 1
		loop do
			q, r = n.divmod(d)
			break unless 0 == r

			n = q
			div_count += 1
		end

		factor.push([d, div_count])
		lim = [lim, isqrt(n)].min

		break if lim < d
	end

	(plist = primes_list).each do |d|
		break if lim < d
		divide.call(d) if 0 == n % d
	end

	if plist.last < lim
		d = plist.last - plist.last % 30 - 1
		while d <= lim
			# [2, 6, 4, 2, 4, 2, 4, 6] are difference of [1, 7, 11, 13, 17, 19, 23, 29]
			d += 2
			divide.call(d) if 0 == n % d
			d += 6
			divide.call(d) if 0 == n % d
			d += 4
			divide.call(d) if 0 == n % d
			d += 2
			divide.call(d) if 0 == n % d
			d += 4
			divide.call(d) if 0 == n % d
			d += 2
			divide.call(d) if 0 == n % d
			d += 4
			divide.call(d) if 0 == n % d
			d += 6
			divide.call(d) if 0 == n % d
		end
	end

	# n is prime?
	if 1 < n and isqrt(n) <= lim
		factor.push([n, 1])
		n = 1
	end
	return factor, n
end

# Param::  positive integer n
# Return:: factor a and b (a <= b) if found else false
def differences_of_squares(n, limit = 1_000_000)
	sqrt = isqrt(n)
	dx = (sqrt << 1) + 1
	dy = 1
	r = sqrt ** 2 - n
	terms = 0

	# find x and y s.t. x**2 - y**2 == n
	loop do
		while 0 < r
			r -= dy
			dy += 2
		end

		break if 0 == r

		r += dx
		dx += 2

		terms += 1
		return false if limit == terms
	end

	return (dx - dy) >> 1, (dx + dy - 2) >> 1
end

# Param::  positive integer n
#          integer c which is used recurrence formula x ** 2 + c (mod n)
#          integer s starting value of the recurrence formula
#          integer max number of trials
# Return:: a factor f (1 < f < n) if found else nil
def pollard_rho(n, c = 1, s = 2, max = 10_000)
	u = s
	v = (s ** 2 + c) % n
	range = 1
	product = 1
	terms = 0

	loop do
		range.times do
			v = (v ** 2 + c) % n
			temp = product * (u - v) % n
			if 0 == temp
				g = lehmer_gcd(n, product)
				return (1 < g) ? g : nil
			end
			product = temp
			terms += 1

			if terms & 1023 == 0
				g = lehmer_gcd(n, product)
				return g if 1 < g
				return nil if max <= terms
			end
		end

		# reset
		u = v
		range <<= 1
		range.times { v = (v ** 2 + c) % n }
	end
end

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
		g = lehmer_gcd(m - 1, n)
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

		g = lehmer_gcd(m - 1, n)
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
			g = lehmer_gcd(m - 1, n)
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

# Param::  integer n
# Return:: factorization of n s.t. [[a, b], [c, d], ...], n == a**b * c**d * ...
#          if n == -1 or 0 or 1 then return [[n, 1]].
#          if n < 0 then [-1, 1] is added as a factor.
#          otherwise find prime factors.
def factorize(n)
	if n <= 1
		return [[n, 1]] if -1 <= n
		n = -n
		factor = [[-1, 1]]
	else
		factor = []
	end

	f, n = trial_division(n, td_lim = 100_000)
	factor += f
	td_lim_square = td_lim ** 2

	merge = Proc.new do |f1, f2|
		next f2 if f1.empty?

		insert_pos = 0
		until f2.empty?
			d, e = f2.first
			insert_pos = Bisect.bisect_left(f1.map(&:first), d, insert_pos)
			break if f1.size <= insert_pos

			if f1[insert_pos][0] == d
				f1[insert_pos][1] += e
				f2.shift
			else
				f1.insert(insert_pos, f2.shift)
			end
			insert_pos += 1
		end

		next f1 + f2
	end

	check_finish = Proc.new do
		if n <= td_lim_square or prime?(n)
			return factor if 1 == n
			return merge.call(factor, [[n, 1]])
		end
	end

	divide = Proc.new do |f|
		f.size.times do |i|
			d = f[i][0]
			loop do
				q, r = n.divmod(d)
				break unless 0 == r
				n = q
				f[i][1] += 1
			end
		end

		next f
	end

	check_finish.call

	# pollard_rho
	loop do
		c = nil
		loop do
			c = rand(n - 3) + 1
			break unless c.square?
		end
		s = rand(n)
		f = pollard_rho(n, c, s, 10_000)
		break unless f

		# f is prime?
		n /= f
		if f <= td_lim_square or prime?(f)
			f = divide.call([[f, 1]])
		else
			f = divide.call(factorize(f))
		end

		factor = merge.call(factor, f)
		check_finish.call
	end

	# p_minus_1
	loop do
		f = p_minus_1(n, 10_000)
		break unless f

		# f is prime?
		n /= f
		if f <= td_lim_square or prime?(f)
			f = divide.call([[f, 1]])
		else
			f = divide.call(factorize(f))
		end

		factor = merge.call(factor, f)
		check_finish.call
	end

	# MPQS
	loop do
		f = mpqs(n)
		break unless f

		# f is prime?
		n /= f
		if f <= td_lim_square or prime?(f)
			f = divide.call([[f, 1]])
		else
			f = divide.call(factorize(f))
		end

		factor = merge.call(factor, f)
		check_finish.call
	end

	raise [factor, n].to_s
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
