class MPQS
	def initialize(n, factor_base_size = nil, sieve_range = nil)
		@n = n
		t = get_default_parameter
		# #decide factor_base_size and sieve_range
		@factor_base_size = factor_base_size || t[0]
		@sieve_range = sieve_range || t[1]
		@sieve_range_2 = @sieve_range << 1
	end

	def mpqs
		n = @n
		factor_base_size = @factor_base_size

		multiplier = n & 7
		n = @n *= multiplier if 1 < multiplier

		# Select factor base
		factor_base = [-1, 2]
		(3..INFINITY).each_prime do |p|
			if 1 == kronecker_symbol(n, p)
				factor_base.push(p)
				break if factor_base_size <= factor_base.size
			end
		end
		factor_base_log = [nil] + factor_base[1..-1].map{|p| Math.log(p)}
		mod_sqrt_cache = Array.new(factor_base_size)
		@power_limit = Array.new(factor_base_size)
		(2...factor_base_size).each do |i|
			p = factor_base[i]
			mod_sqrt_cache[i] = []
			@power_limit[i] = (factor_base_log.last / factor_base_log[i]).ceil
			#@power_limit[i] = (Math.log(@sieve_range_2, factor_base_log[i])).floor

			mod_sqrt_cache[i] = [nil] + mod_sqrt(n, p, @power_limit[i], true)
		end

		@factor_base = factor_base
		@factor_base_log = factor_base_log
		@mod_sqrt_cache = mod_sqrt_cache

		target = Math.log(n) / 2 + Math.log(@sieve_range)
		@closenuf = target - 1.5 * Math.log(factor_base.last)

		# MPQS
		factorization = []
		r_list = []
		big_prime_sup = []

		a = next_prime(isqrt(n << 1) / @sieve_range)
		if MAX_THREAD == 1
			loop do
				a = next_prime(a) until b = mod_sqrt(n, a)
				c = (b ** 2 - n) / a
#				a, b, c = next_poly
				f, r, big = sieve(a, b, c)
				unless f.empty?
					factorization += f
					r_list += r
					big_prime_sup += big
					break if @factor_base_size + 5 < factorization.size
				end

				a = next_prime(a)
			end
		else
			loop do
				# parallelization
				threads = Array.new(MAX_THREAD)

				MAX_THREAD.times do |i|
					a = next_prime(a) until b = mod_sqrt(n, a)
					threads[i] = Thread.new(a) do |a|
						sieve(a, b)
					end
					a = next_prime(a)
				end

				MAX_THREAD.times do |i|
					f, r, big = threads[i].value

					if 1 < f.size
						factorization += f
						r_list += r
						big_prime_sup += big
						break if @factor_base_size + 9 < factorization.size
					end
				end

				break if @factor_base_size + 9 < factorization.size
			end
		end

		# Gaussian elimination
		rslt = gaussian_elimination(factorization)

		rslt.each do |row|
			x = y = 1
			f = Array.new(factor_base_size, 0)
			row.each.with_index do |b, i|
				next if b == 0
				x = x * r_list[i] % n
				f = f.zip(factorization[i]).map{|a, b| a + b}
				y = y * big_prime_sup[i] % n# # if big_prime_sup[i]
			end

			(2...factor_base_size).each do |i|
				y = y * power(factor_base[i], f[i] >> 1, n) % n
			end
			y = (y << (f[1] >> 1)) % n
			y = -y if f[0][1] == 1

			z = lehmer_gcd(x - y, n)
			raise "Modulo Error!" if 1 == z and 1 == lehmer_gcd(x + y, n)# #

			if 1 < z and z < n and z != multiplier
				q, r = z.divmod(multiplier)
				return (0 == r) ? q : z
			end
		end

		return false
	end

	def get_default_parameter
		parameters_for_mpqs = [
			[100,20], #9 -digits
			[100,21], #10
			[100,22], #11
			[100,24], #12
			[100,26], #13
			[100,29], #14
			[100,32], #15
			[200,35], #16
			[300,40], #17
			[300,60], #18
			[300,80], #19
			[300,100], #20
			[300,100], #21
			[300,120], #22
			[300,140], #23
			[600,160], #24
			[900,180], #25
			[1000,200], #26
			[1000,220], #27
			[2000,240], #28
			[2000,260], #29
			[2000,325], #30
			[2000,355], #31
			[2000,375], #32
			[3000,400], #33
			[2000,425], #34
			[2000,550], #35
			[3000,650], #36
			[5000,750], #37
			[4000,850], #38
			[4000,950], #39
			[5000,1000], #40
			[14000,1150], #41
			[15000,1300], #42
			[15000,1600], #43
			[15000,1900], #44
			[15000,2200], #45
			[20000,2500], #46
			[25000,2500], #47
			[27500,2700], #48
			[30000,2800], #49
			[35000,2900], #50
			[40000,3000], #51
			[50000,3200], #52
			[50000,3500]] #53

		k = Math.log(@n, 10).floor - 8
		k = 0 if k < 0
		t = parameters_for_mpqs[k].reverse
		t[1] *= 5
		return t
	end

	# Return:: a, b,c
	def next_poly
		@d = d = next_d
		a = d ** 2
		h1 = power(@n, (d >> 2) + 1, d)
		h2 = ((@n - h1 ** 2) / d % d) * extended_lehmer_gcd(h1 << 1, d)[0] % d
		b = h1 + h2 * d
		b = a - b if b.even?
		c = ((b ** 2 - @n) >> 2) / a

		return [a, b, c]
	end

	def next_d
		unless @d
			@d = isqrt(isqrt(@n >> 1) / @sieve_range)
			@d -= 1 + @d & 3
		end

		d = @d + 4
		if d < primes_list.last
			plist = primes_list
			(d..plist.last).each_prime do |p|
				return p if p[1] == 1 and kronecker_symbol(@n, p) == 1
			end
			d += 4
		end

		loop do
			return d if power(@n, d >> 1, d) == 1
			d += 4
		end
	end

	def sieve(a, b, c)
		n = @n
		factor_base_size = @factor_base_size
		sieve_range = @sieve_range
		factor_base = @factor_base
		factor_base_log = @factor_base_log

		t = -b / a
#		t = -((b >> 1) / a)
		lo = t - sieve_range + 1
		hi = t + sieve_range

		sieve = Array.new(@sieve_range_2)
		lo_minus_1 = lo - 1
		t = a * lo_minus_1 + b
		b2 = b << 1
		a2 = a << 1
		t2 = (a * lo_minus_1 + b2) * lo_minus_1 + c
		diff = a2 * lo - a + b2
		(lo..hi).each.with_index do |r, i|
			t += a
			t2 += diff
			diff += a2
			sieve[i] = [t, 0, t2]
		end

		# 2
		s = sieve[0][0].odd? ? 0 : 1
		s.step(@sieve_range_2 - 1, 2) do |i|
			count = 3
			count += 1 while sieve[i][2][count] == 0
			sieve[i][1] += factor_base_log[1] * count
		end

		# 3, ...
		(2...factor_base_size).each do |i|
			p = factor_base[i]
			a_inverse = extended_lehmer_gcd(a, p)[0]
	#if p == multiplier
	#	t = 0
	#	s = (t - lo) % p
	#	s.step((@sieve_range_2) - 1, p) do |j|
	#		sieve[j][1] += factor_base_log[i]
	#	end
	#else
			pe = 1
			(1..@power_limit[i]).each do |e|
				pe *= p
				sqrt = @mod_sqrt_cache[i][e]
				[sqrt, pe - sqrt].each do |t|
					s = ((t - b) * a_inverse - lo) % pe
					s.step(@sieve_range_2 - 1, pe) do |j|
						sieve[j][1] += factor_base_log[i]
					end
				end
			end
	#end
		end

		# trial division on factor base
		sieve = sieve.select{|i| @closenuf < i[1]}
#p sieve.size

		factorization = []
		factorization_2 = []
		r_list = []
		r_list_2 = []
		big_prime = {}
		big_prime_sup = []
		sieve.map do |r, z, s|
			f, re = trial_division_on_factor_base(s, factor_base)
			if 1 == re
				factorization.push(f)
				r_list.push(r)
			else
				unless big_prime[re]
					big_prime[re] = [f, r]
				else
					r_list_2.push(r * big_prime[re][1])
					big_prime_sup.push(re * a)
					factorization_2.push(big_prime[re][0].zip(f).map{|a, b| a + b})
				end
			end
		end

		if factorization.size < 2
			return factorization_2, r_list_2, big_prime_sup
		end

		# Eliminate 'a'
		fa1 = factorization.shift
		r = r_list.shift

		r_list = r_list.map{|i| i * r - n} + r_list_2
		big_prime_sup = Array.new(factorization.size, a) + big_prime_sup
		factor_base_size.times do |j|
			next if 0 == fa1[j]
			t = fa1[j]
			factorization.size.times do |i|
				factorization[i][j] += t
			end
		end
		factorization += factorization_2

		return factorization, r_list, big_prime_sup
	end

	def gaussian_elimination(m)
		m = m.map{|row| row.reverse_each.map{|i| i[0]}}

		rslt = Array.new(m.size)
		m.size.times do |i|
			rslt[i] = Array.new(m.size, 0)
			rslt[i][i] = 1
		end

		height = m.size
		width = m[0].size

		width.times do |j|
			# Find non-zero entry
			row = nil
			(j...height).each do |i|
				if 0 != m[i][j]
					row = i
					break
				end
			end
			next unless row

			# Swap?
			if j < row
				m[row], m[j] = m[j], m[row]
				rslt[row], rslt[j] = rslt[j], rslt[row]
			end

			m_j = m[j]
			rslt_j = rslt[j]
			# Eliminate
			((j + 1)...height).each do |i|
				next if m[i][j] == 0

				m_i = m[i]
				rslt_i = rslt[i]
				((j + 1)...width).each do |j2|
					m_i[j2] ^= 1 if 1 == m_j[j2]
				end
				height.times do |j2|
					rslt_i[j2] ^= 1 if 1 == rslt_j[j2]
				end
			end
		end

		return rslt.pop(height - width)
	end

	def trial_division_on_factor_base(n, factor_base)
		factor = Array.new(@factor_base_size, 0)
		if n < 0
			factor[0] = 1
			n = -n
		end

		i = 1
		while i < @factor_base_size
			d = factor_base[i]
			q, r = n.divmod(d)
			if 0 == r
				n = q
				div_count = 1
				loop do
					q, r = n.divmod(d)
					break unless 0 == r

					n = q
					div_count += 1
				end

				factor[i] = div_count
			end

			i += 1
		end

		return factor, n
	end

	def compose(f)
		rslt = 1
		f.each.with_index do |e, i|
			rslt *= @factor_base[i] ** e
		end
		return rslt
	end
end

def mpqs(n, factor_base_size = nil, sieve_range = nil)
	mpqs = MPQS.new(n, factor_base_size, sieve_range)
	return mpqs.mpqs
end

__END__
multiplier導入

a,b,cの決め方

dはpseudo primeで良い

factor_base の内容を逆順に

素因数分解＆GCDのループ → 完全に分解できる数を最小限で済ませる。

next_probably_prime 導入

IO.popen のパイプによるRubyプロセス間でのバイナリデータの送受信
 → マルチスレッド＆マルチプロセス化


■有効だった改良
・乗除算の削減（特にsieveの初期化）
・a のeliminate
・パラメータの調整
