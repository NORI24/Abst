class MPQS
	@@kronecker_table = nil
	@@fixed_factor_base = [-1, 2, 3, 5, 7, 11, 13].freeze
	@@fixed_factor_base_log = ([nil] + @@fixed_factor_base[1..-1].map {|p| Math.log(p)}).freeze
	@@mpqs_parameter_map = [[100,20]] * 9 + [
		[100, 20],		# 9 -digits
		[100, 21],		# 10
		[100, 22],		# 11
		[100, 24],		# 12
		[100, 26],		# 13
		[100, 29],		# 14
		[100, 32],		# 15
		[200, 35],		# 16
		[300, 40],		# 17
		[300, 60],		# 18
		[300, 80],		# 19
		[300, 100],		# 20
		[300, 100],		# 21
		[300, 120],		# 22
		[300, 140],		# 23
		[600, 160],		# 24
		[900, 180],		# 25
		[1000, 200],	# 26
		[1000, 220],	# 27
		[2000, 240],	# 28
		[2000, 260],	# 29
		[2000, 325],	# 30
		[2000, 355],	# 31
		[2000, 375],	# 32
		[3000, 400],	# 33
		[2000, 425],	# 34
		[2000, 550],	# 35
		[3000, 650],	# 36
		[5000, 750],	# 37
		[4000, 850],	# 38
		[4000, 950],	# 39
		[5000, 1000],	# 40
		[14000, 1150],	# 41
		[15000, 1300],	# 42
		[15000, 1600],	# 43
		[15000, 1900],	# 44
		[15000, 2200],	# 45
		[20000, 2500],	# 46
		[25000, 2500],	# 47
		[27500, 2700],	# 48
		[30000, 2800],	# 49
		[35000, 2900],	# 50
		[40000, 3000],	# 51
		[50000, 3200],	# 52
		[50000, 3500]]	# 53

	def initialize(n)
		@original_n = n
		@big_prime = {}

		decide_multiplier(n)
		decide_parameter
		select_factor_base
		some_precomputations
	end

	def self.kronecker_table
		unless @@kronecker_table
			target = [3, 5, 7, 11, 13]
			@@kronecker_table = 4.times.map{Hash.new}
			(17..3583).each_prime do |p|
				k = target.map {|b| kronecker_symbol(p, b)}
				@@kronecker_table[(p & 6) >> 1][k] ||= p
			end
			@@kronecker_table[0][[1, 1, 1, 1, 1]] = 1
		end

		return @@kronecker_table
	end

	def decide_multiplier(n)
		t = [3, 5, 7, 11, 13].map {|p| kronecker_symbol(n, p)}
		multiplier = self.class.kronecker_table[(n & 6) >> 1][t]
		@n = n * multiplier
	end

	def decide_parameter
		digit = Math.log(@n, 10).floor
		parameter = @@mpqs_parameter_map[digit].dup
		parameter[0] *= 2
		@sieve_range, @factor_base_size = parameter
		@sieve_range_2 = @sieve_range << 1
	end

	def select_factor_base
		@factor_base = @@fixed_factor_base.dup
		(17..INFINITY).each_prime do |p|
			if 1 == kronecker_symbol(@n, p)
				@factor_base.push(p)
				break if @factor_base_size <= @factor_base.size
			end
		end
	end

	def some_precomputations
		size  = @@fixed_factor_base_log.size
		@factor_base_log = @@fixed_factor_base_log + @factor_base[size..-1].map {|p| Math.log(p)}

		@power_limit = Array.new(@factor_base_size)
		@mod_sqrt_cache = Array.new(@factor_base_size)
		(2...@factor_base_size).each do |i|
			p = @factor_base[i]
			@power_limit[i] = (@factor_base_log.last / @factor_base_log[i]).floor
			@mod_sqrt_cache[i] = [nil] + mod_sqrt(@n, p, @power_limit[i], true)
		end

		target = Math.log(@n) / 2 + Math.log(@sieve_range) - 1
		@closenuf = target - 1.8 * Math.log(@factor_base.last)
	end

	def find_factor
		# Sieve
		r_list = []
		factorization = []
		big_prime_sup = []
		loop do
			a, b, c, d = next_poly
			f, r, big = sieve(a, b, c, d)
			unless f.empty?
				factorization += f
				r_list += r
				big_prime_sup += big
				break if @factor_base_size + 5 < factorization.size
			end
		end

		# Gaussian elimination
		rslt = gaussian_elimination(factorization)
		rslt.each do |row|
			x = y = 1
			f = Array.new(@factor_base_size, 0)
			factorization.size.times do |i|
				next if row[i] == 0
				x = x * r_list[i] % @n
				f = f.zip(factorization[i]).map{|a, b| a + b}
				y = y * big_prime_sup[i] % @n
			end

			(2...@factor_base_size).each do |i|
				y = y * power(@factor_base[i], f[i] >> 1, @n) % @n
			end
			y = (y << (f[1] >> 1)) % @n
			y = -y if f[0][1] == 1

			z = lehmer_gcd(x - y, @original_n)
			return z if 1 < z and z < @original_n
# #
raise "Modulo Error!" if 1 == z and 1 == lehmer_gcd(x + y, @original_n)
		end

		return false
	end

	# Return:: a, b,c
	def next_poly
		@d = d = next_d
		a = d ** 2
		h1 = power(@n, (d >> 2) + 1, d)
		h2 = ((@n - h1 ** 2) / d) * extended_lehmer_gcd(h1 << 1, d)[0] % d
		b = h1 + h2 * d
		b = a - b if b.even?
		c = ((b ** 2 - @n) >> 2) / a

		return a, b, c, d
	end

	def next_d
		unless @d
			@d = isqrt(isqrt(@n >> 1) / @sieve_range)
			@d -= 1 + (@d & 3)
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

	def sieve(a, b, c, d)
		t = -((b >> 1) / a)
		lo = t - @sieve_range + 1
		hi = t + @sieve_range

		sieve = Array.new(@sieve_range_2)
		lo_minus_1 = lo - 1

		b2 = b << 1
		a2 = a << 1
		t = a * lo_minus_1
		t2 = (t + b) * lo_minus_1 + c
		t = t << 1
		diff = t + a + b
		t += b
		(lo..hi).each.with_index do |r, i|
			t += a2
			t2 += diff
			diff += a2
			sieve[i] = [t, 0, t2]
		end

		# Sieve by 2
#		s = sieve[0][0].odd? ? 0 : 1
#		s.step(@sieve_range_2 - 1, 2) do |i|
#		(0...@sieve_range_2).each do |i|
#			count = 1
#			count += 1 while sieve[i][2][count] == 0
#			sieve[i][1] += @factor_base_log[1] * count
#		end

		# Sieve by 3, 5, 7, 11, ...
#		(2...@factor_base_size).each do |i|
		(4...@factor_base_size).each do |i|
			p = @factor_base[i]
			a_inverse = extended_lehmer_gcd(a2, p ** @power_limit[i])[0]
			pe = 1
			e = 1

			power_limit_i = @power_limit[i]
			factor_base_log_i = @factor_base_log[i]
			mod_sqrt_cache_i = @mod_sqrt_cache[i]
			while e <= power_limit_i
				pe *= p
				sqrt = mod_sqrt_cache_i[e]

				t = sqrt
				s = ((t - b) * a_inverse - lo) % pe
				s.step(@sieve_range_2 - 1, pe) do |j|
					sieve[j][1] += factor_base_log_i
				end

				t = pe - sqrt
				s = ((t - b) * a_inverse - lo) % pe
				s.step(@sieve_range_2 - 1, pe) do |j|
					sieve[j][1] += factor_base_log_i
				end

				e += 1
			end
		end

		# trial division on factor base
		sieve = sieve.select{|i| @closenuf < i[1]}

		factorization = []
		factorization_2 = []
		r_list = []
		r_list_2 = []
		big_prime_sup = []
		big_prime_sup_2 = []
		sieve.map do |r, z, s|
			f, re = trial_division_on_factor_base(s, @factor_base)
			if 1 == re
				f[1] += 2
				factorization.push(f)
				r_list.push(r)
				big_prime_sup.push(d)
			else
				unless @big_prime[re]
					@big_prime[re] = [f, r, d]
				else
					r_list_2.push(r * @big_prime[re][1])
					t = @big_prime[re][2]
					t = (d == t) ? a : d * t
					big_prime_sup_2.push(re * t)
					t = @big_prime[re][0].zip(f).map{|a, b| a + b}
					t[1] += 4
					factorization_2.push(t)
				end
			end
		end

#p [sieve.size, factorization.size, factorization_2.size]
#sleep 0.2
		if factorization_2.size < 1
			return factorization, r_list, big_prime_sup
		end

		r_list += r_list_2
		big_prime_sup += big_prime_sup_2
		factorization += factorization_2

		return factorization, r_list, big_prime_sup
	end

	def gaussian_elimination(m)
		m = m.map{|row| row.reverse_each.map{|i| i[0]}}

		rslt = Array.new(m.size)
		t = 1
		m.size.times do |i|
			rslt[i] = t
			t <<= 1
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

			# Eliminate
			m_j = m[j]
			((j + 1)...height).each do |i|
				next if m[i][j] == 0

				m_i = m[i]
				((j + 1)...width).each do |j2|
					m_i[j2] ^= 1 if 1 == m_j[j2]
				end
				rslt[i] ^= rslt[j]
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

def mpqs(n)
	mpqs = MPQS.new(n)
	return mpqs.find_factor
end

__END__
素因数分解＆GCDのループ → 完全に分解できる数を最小限で済ませる。

sieve多重配列を分割し、参照を高速化

IO.popen のパイプによるRubyプロセス間でのバイナリデータの送受信
 → マルチスレッド＆マルチプロセス化


■有効だった改良
・乗除算の削減（特にsieveの初期化）
・多項式の係数を工夫（aを平方数とする）
・パラメータの調整
・適切なmultiplierの使用
・2,3 での篩を行わない
・複数の多項式に跨る大きな素因数の利用

