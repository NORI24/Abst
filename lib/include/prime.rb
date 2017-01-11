module Abst
	module_function

	#
	# Precomputation
	#

	$precomputed_sieve = nil
	def precomputed_sieve
		precompute_sieve(DEFAULT_SIEVE_SIZE) unless $precomputed_sieve
		return $precomputed_sieve
	end

	$precomputed_primes = nil
	def precomputed_primes
		precompute_sieve(DEFAULT_SIEVE_SIZE) unless $precomputed_sieve
		return $precomputed_primes
	end

	# Compute eratosthenes sieve.
	# Cache the sieve array and primes.
	def precompute_sieve(n)
		n = 100 if n < 100
		return if $precomputed_sieve && (n + 1) >> 1 <= $precomputed_sieve.size

		primes = [2]

		# make array for sieve
		sieve_len_max = (n + 1) >> 1
		sieve = [nil]
		sieve_len = sieve.size
		k = 3
		i = 1
		while sieve_len < sieve_len_max
			if sieve[i].nil?
				primes << k
				sieve_len *= k
				if sieve_len_max < sieve_len
					sieve_len /= k
					# adjust sieve list length
					sieve *= sieve_len_max / sieve_len
					sieve += sieve[0...(sieve_len_max - sieve.size)]
					sieve_len = sieve_len_max
				else
					sieve *= k
				end

				i.step(sieve_len - 1, k) do |j|
					sieve[j] = k
				end
			end

			k += 2
			i += 1
		end

		# Set sieve[prime] = nil
		(1...i).each do |j|
			sieve[j] = nil if sieve[j] == (j << 1) + 1
		end

		# sieve
		limit = (isqrt(n) - 1) >> 1
		while i <= limit
			unless sieve[i]
				primes << (k = (i << 1) + 1)
				j = (k ** 2) >> 1
				while j < sieve_len_max
					sieve[j] = k
					j += k
				end
			end

			i += 1
		end

		# output result
		limit = (n - 1) >> 1
		while i <= limit
			primes << (i << 1) + 1 unless sieve[i]
			i += 1
		end

		$precomputed_primes = primes
		$precomputed_sieve = sieve
	end

	#
	# primality test
	#

	# Param::  positive integer n
	#          positive integer base
	# Return:: boolean whether n passes a pseudoprime test for the base or not
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

	# Primality test
	# Param::  positive integer n > 2
	#          factor is factorization of n - 1
	# Return:: boolean whether n is prime or not
	def n_minus_1(n, factor = nil)
		factor = factorize(n - 1) unless factor
		factor.shift if 2 == factor[0][0]

		n_1 = n - 1
		half_n_1 = n_1 >> 1

		primes = precomputed_primes.each
		find_base = proc do
			b = primes.next
			until (t = power(b, half_n_1, n)) == n_1
				return false unless t == 1
				b = primes.next
			end
			b
		end

		base = find_base.call
		factor.each do |prime, e|
			while power(base, half_n_1 / prime, n) == n_1
				base = find_base.call
			end
		end

		return true
	end

	# Primality test
	# Param::  positive integer n
	# Return:: boolean whether n is prime or not
	def apr(n)
		raise NotImplementedError
	end

	# Param::  positive integer n
	# Return:: boolean whether n is prime or not
	def prime?(n)
		return 1 < n if n <= 3

		if n <= precomputed_sieve.size * 2 + 2
			return Bisect.index(precomputed_primes, n) ? true : false
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
		return n_minus_1(n)
	end

	# Lucas-Lehmer primality test
	# Param::  odd prime p
	# Return:: boolean whether M(p) == 2**p - 1 is prime or not
	#          there M(p) means p-th Mersenne number
	def lucas_lehmer(p)
		s = 4
		m = (1 << p) - 1
		(p - 2).times {s = (s * s - 2) % m}
		return 0 == s
	end

	#
	# factorization
	#

	# Param::  positive integer n >= 2
	#          positive integer limit
	# Return:: factorization up to limit and remainder of n i.e.
	#          [[[a, b], [c, d], ...], r] s.t.
	#          n == a**b * c**d * ... * r, (r have no factor less than or equal to limit)
	def trial_division(n, limit = INFINITY)
		factor = []
		lim = [limit, isqrt(n)].min

		divide = lambda do |d|
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

			lim < d
		end

		(plist = precomputed_primes).each do |d|
			break if lim < d
			break if 0 == n % d and divide.call(d)
		end

		if plist.last < lim
			d = plist.last - plist.last % 30 - 1
			while d <= lim
				# [2, 6, 4, 2, 4, 2, 4, 6] are difference of [1, 7, 11, 13, 17, 19, 23, 29]
				# which are prime bellow 30 == 2 * 3 * 5 except 2, 3, 5
				[2, 6, 4, 2, 4, 2, 4, 6].each do |diff|
					d += diff
					break if 0 == n % d and divide.call(d)
				end
			end
		end

		# n is prime?
		if 1 < n and n <= (lim + 1) ** 2 - 1
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
	#          positive integer bound <= DEFAULT_SIEVE_SIZE
	#          positive integer m (2 <= m < n)
	# Return:: a factor f (1 < f < n) if found else nil
	def p_minus_1(n, bound = 10_000, m = 2)
		plist = precomputed_primes

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
	# Return:: prime factorization of n s.t. [[p_1, e_1], [p_2, e_2], ...]
	#          n == p_1**e_1 * p_2**e_2 * ... (p_1 < p_2 < ...)
	#          if |n| <= 1 then return [[n, 1]].
	#          if n < 0 then [-1, 1] is added as a factor.
	def factorize(n)
		factor = []
		if n <= 1
			return [[n, 1]] if -1 <= n
			n = -n
			factor << [-1, 1]
		end

		found_factor, n = trial_division(n, td_lim = 10_000)
		factor += found_factor
		td_lim_square = (td_lim + 1) ** 2 - 1

		check_finish = lambda do
			if n <= td_lim_square or prime?(n)
				factor << [n, 1] unless 1 == n
				return true
			end
			return false
		end

		return factor if check_finish.call

		divide = lambda do |f|
			f.size.times do |i|
				d = f[i][0]
				loop do
					q, r = n.divmod(d)
					break unless 0 == r
					n = q
					f[i][1] += 1
				end
			end

			return f
		end

		# pollard_rho
		loop do
			c = nil
			loop do
				c = rand(n - 3) + 1
				break unless c.square?
			end
			s = rand(n)
			f = pollard_rho(n, c, s, 50_000)
			break unless f

			# f is prime?
			n /= f
			if f <= td_lim_square or prime?(f)
				factor += divide.call([[f, 1]])
			else
				factor += divide.call(factorize(f))
			end

			return factor.sort if check_finish.call
		end

		# MPQS
		loop do
			f = mpqs(n)
			break unless f

			# f is prime?
			n /= f
			if f <= td_lim_square or prime?(f)
				factor += divide.call([[f, 1]])
			else
				factor += divide.call(factorize(f))
			end

			return factor.sort if check_finish.call
		end

		raise [factor.sort, n].to_s
	end

	#
	# generation
	#

	def eratosthenes_sieve(n)
		return to_enum(:eratosthenes_sieve, n) unless block_given?

		return if n < 2

		yield 2
		return if 2 == n

		yield 3

		# make list for sieve
		sieve_len_max = (n + 1) >> 1
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
					sieve *= k
				end

				i.step(sieve_len - 1, k) do |j|
					sieve[j] = false
				end
			end

			k += 2
			i += 1
		end

		# sieve
		limit = (isqrt(n) - 1) >> 1
		while i <= limit
			if sieve[i]
				yield k = (i << 1) + 1
				j = (k ** 2) >> 1
				while j < sieve_len_max
					sieve[j] = false
					j += k
				end
			end

			i += 1
		end

		# output result
		limit = (n - 1) >> 1
		while i <= limit
			yield((i << 1) + 1) if sieve[i]
			i += 1
		end
	end

	# Param::  integer max
	# Return:: hash of factorization of 2..max
	def consecutive_factorization(max)
		rslt = Hash.new do |hash, key|
			next nil unless key.kind_of?(Integer)
			next nil if key <= 1 or max < key
			i = 1
			i += 1 while key[i] == 0
			t = key >> i
			1 == t ? [[2, i]] : hash[t].dup.unshift([2, i])
		end

		3.step(max, 2) do |n|
			next if rslt.has_key?(n)
			rslt[n] = [[n, 1]]
			(n * 3).step(max, n << 1) do |m|
				rslt[m] = [m] unless rslt.has_key?(m)
				t = rslt[m].last / n
				e = 1
				loop do
					q, r = t.divmod(n)
					break unless 0 == r
					t = q
					e += 1
				end

				rslt[m][-1, 0] = [[n, e]]
				if 1 == t
					rslt[m].pop
				else
					rslt[m][-1] = t
				end
			end
		end

		return rslt
	end

	# Param::  integer n
	# Return:: The least prime greater than n
	def next_prime(n)
		return Bisect.find_gt(precomputed_primes, n) if n < precomputed_primes.last

		n += (n.even? ? 1 : 2)
		n += 2 until prime?(n)

		return n
	end

	# Euler's totient function
	def totient(n)
		return 1 if 1 == n
		return n - 1 if prime?(n)

		return factorize(n).inject(1) {|r, i| r * i[0] ** (i[1] - 1) * (i[0] - 1)}
	end

	# Compute moebius function under n^(2/3).
	# Param: Integer n
	# Return: Array return[i] == moebius(i).
	def moebius_sieve(n)
		sieve = Array.new(n + 1)
		sieve[1] = 1

		# sieve on odd numbers
		d = 3
		while d <= n
			if sieve[d]
				# sieve[d] has number of prime divisors if d is squarefree otherwise 0.
				if 0 < sieve[d]
					sieve[d] = sieve[d].even?? 1 : -1
				end
			else
				# Now d is prime
				sieve[d] = -1

				# non squeare free
				(d ** 2).step(n, (d ** 2) << 1) do |j|
					sieve[j] = 0
				end

				# Increment sieve[j] it has number of prime divisors.
				(3 * d).step(n, d << 1) do |j|
					next if sieve[j] == 0
					sieve[j] = (sieve[j] || 0) + 1
				end
			end

			d += 2
		end

		# sieve on even numbers
		2.step(n, 4) do |i|
			sieve[i] = -sieve[i >> 1]
		end
		4.step(n, 4) do |i|
			sieve[i] = 0
		end

		return sieve
	end

	$mertens_cache_2 = {}
	def mertens(n)
		if n < $mertens_cache.size
			return $mertens_cache[n]
		end

		rslt = $mertens_cache_2[n]
		unless rslt
			rslt = 0
			d = 2
			while d <= n
				q = n / d
				next_d = n / q + 1
				rslt += mertens(q) * (next_d - d)
				d = next_d
			end

			rslt = 1 - rslt
			$mertens_cache_2[n] = rslt
		end

		return rslt
	end

	# Param: Integer n
	# Return: Sum of totient(i) for (1 <= i <= n)
	def totient_sum(n)
		n_23 = (n ** (2/3r)).to_i

		# Compute moebius function under n^(2/3) by sieve
		moebius_sieve_rslt = moebius_sieve(n_23)

		# Compute mertens under n^(2/3)
		$mertens_cache = Array.new(n_23 + 1)
		$mertens_cache[0] = 0
		i = 1
		while i <= n_23
			$mertens_cache[i] = $mertens_cache[i - 1] + moebius_sieve_rslt[i]
			i += 1
		end

		rslt = 1
		d = 2
		while d <= n
			a = n / d
			next_d = n / a + 1
			m = mertens(a)
			rslt += (d + next_d - 3) * (next_d - d) / 2 * m
			d = next_d
		end

		return rslt
	end
end

class Range
	def each_prime()
		return to_enum(:each_prime) unless block_given?

		primes = Abst.precomputed_primes

		max = last + (exclude_end? ? -1 : 0)
		if (first <= primes.last)
			a = Bisect.bisect_left(primes, first)
			a.upto(primes.size - 1) do |i|
				return if max < primes[i]
				yield primes[i]
			end
		end

		s = primes.last + 2
		s.step(max, 2) do |i|
			yield i if prime?(i)
		end
	end
end
