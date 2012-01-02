require 'thread'

module ANT
	module_function

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

@@proc_time = Hash.new(0)
def self.get_times
	return @@proc_time
end

		def self.kronecker_table
			unless @@kronecker_table
				target = [3, 5, 7, 11, 13]
				@@kronecker_table = 4.times.map{Hash.new}
				(17..3583).each_prime do |p|
					k = target.map {|b| ANT.kronecker_symbol(p, b)}
					@@kronecker_table[(p & 6) >> 1][k] ||= p
				end
				@@kronecker_table[0][[1, 1, 1, 1, 1]] = 1
			end

			return @@kronecker_table
		end

		def initialize(n, thread_num)
@@proc_time[:init] -= Time.now.to_i + Time.now.usec.to_f / 10 ** 6
			@original_n = n
			@thread_num = [thread_num, 1].max
			@big_prime = {}
			@big_prime_mutex = Mutex.new

			decide_multiplier(n)
			decide_parameter
			select_factor_base
			some_precomputations

			@d = ANT.isqrt(ANT.isqrt(@n >> 1) / @sieve_range)
			@d -= (@d & 3) + 1

			@matrix_left = []
			@matrix_right = []
			@mask = 1
			@check_list = Array.new(@factor_base_size)
@@proc_time[:init] += Time.now.to_i + Time.now.usec.to_f / 10 ** 6
		end

		def decide_multiplier(n)
			t = [3, 5, 7, 11, 13].map {|p| ANT.kronecker_symbol(n, p)}
			multiplier = self.class.kronecker_table[(n & 6) >> 1][t]
			@n = n * multiplier
		end

		def decide_parameter
			digit = Math.log(@n, 10).floor
			parameter = @@mpqs_parameter_map[digit].dup
			parameter[0] = (parameter[0] * 2).floor
			@sieve_range, @factor_base_size = parameter
			@sieve_range_2 = @sieve_range << 1
		end

		def select_factor_base
			@factor_base = @@fixed_factor_base.dup
			(17..INFINITY).each_prime do |p|
				if 1 == ANT.kronecker_symbol(@n, p)
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
			2.upto(@factor_base_size - 1) do |i|
				p = @factor_base[i]
				@power_limit[i] = (@factor_base_log.last / @factor_base_log[i]).floor
				@mod_sqrt_cache[i] = [nil] + ANT.mod_sqrt(@n, p, @power_limit[i], true)
			end

			target = Math.log(@n) / 2 + Math.log(@sieve_range) - 1
			@closenuf = target - 1.8 * Math.log(@factor_base.last)
		end

		def find_factor
			if 1 == @thread_num
				find_factor_single_thread
			else
				sieve_thread_num = [@thread_num - 2, 1].max
				find_factor_multi_thread(sieve_thread_num)
			end
		end

		def find_factor_single_thread
			r_list = []
			factorization = []
			big_prime_sup = []

			loop do
				# Create polynomial
				a, b, c, d = next_poly

				# Sieve
temp = Time.now.to_i + Time.now.usec.to_f / 10 ** 6
				f, r, big = sieve(a, b, c, d)
@@proc_time[:sieve] += Time.now.to_i + Time.now.usec.to_f / 10 ** 6 - temp
				next if f.empty?

				# Gaussian elimination
				factorization += f
				r_list += r
				big_prime_sup += big

@@proc_time[:gaussian] -= Time.now.to_i + Time.now.usec.to_f / 10 ** 6
				eliminated = gaussian_elimination(f)
@@proc_time[:gaussian] += Time.now.to_i + Time.now.usec.to_f / 10 ** 6
				eliminated.each do |row|
					x = y = 1
					f = Array.new(@factor_base_size, 0)
					factorization.size.times do |i|
						next if row[i] == 0
						x = x * r_list[i] % @n
						f = f.zip(factorization[i]).map{|e1, e2| e1 + e2}
						y = y * big_prime_sup[i] % @n
					end

					2.upto(@factor_base_size - 1) do |i|
						y = y * ANT.power(@factor_base[i], f[i] >> 1, @n) % @n
					end
					y = (y << (f[1] >> 1)) % @n

					z = ANT.lehmer_gcd(x - y, @original_n)
					return z if 1 < z and z < @original_n
				end
			end
		end

		def find_factor_multi_thread(sieve_thread_num)
			queue_poly = SizedQueue.new(sieve_thread_num)
			queue_factor = SizedQueue.new(sieve_thread_num)

			# Create thread make polynomials
			th_make_poly = Thread.new do
				loop { queue_poly.push next_poly }
			end

			thg_sieve = ThreadGroup.new
			# Create threads for sieve
			sieve_thread_num.times do
				thread = Thread.new do
					loop do
						a, b, c, d = queue_poly.shift

temp = Time.now.to_i + Time.now.usec.to_f / 10 ** 6
						# Sieve
						f, r, big = sieve(a, b, c, d)
@@proc_time[:sieve] += Time.now.to_i + Time.now.usec.to_f / 10 ** 6 - temp

						queue_factor.push [f, r, big] unless f.empty?
					end
				end
				thg_sieve.add thread
			end

			r_list = []
			factorization = []
			big_prime_sup = []
			loop do
				f, r, big = queue_factor.shift

				# Gaussian elimination
				factorization += f
				r_list += r
				big_prime_sup += big

@@proc_time[:gaussian] -= Time.now.to_i + Time.now.usec.to_f / 10 ** 6
				eliminated = gaussian_elimination(f)
@@proc_time[:gaussian] += Time.now.to_i + Time.now.usec.to_f / 10 ** 6
				eliminated.each do |row|
					x = y = 1
					f = Array.new(@factor_base_size, 0)
					factorization.size.times do |i|
						next if row[i] == 0
						x = x * r_list[i] % @n
						f = f.zip(factorization[i]).map{|e1, e2| e1 + e2}
						y = y * big_prime_sup[i] % @n
					end

					2.upto(@factor_base_size - 1) do |i|
						y = y * ANT.power(@factor_base[i], f[i] >> 1, @n) % @n
					end
					y = (y << (f[1] >> 1)) % @n

					z = ANT.lehmer_gcd(x - y, @original_n)
					return z if 1 < z and z < @original_n
				end
			end
		ensure
			thg_sieve.list.each {|th| th.kill}
			th_make_poly.kill
		end

		# Return:: a, b,c
		def next_poly
temp = Time.now.to_i + Time.now.usec.to_f / 10 ** 6
			@d = d = next_d
			a = d ** 2
			h1 = ANT.power(@n, (d >> 2) + 1, d)
			h2 = ((@n - h1 ** 2) / d) * ANT.extended_lehmer_gcd(h1 << 1, d)[0] % d
			b = h1 + h2 * d
			b = a - b if b.even?
			c = ((b ** 2 - @n) >> 2) / a

@@proc_time[:make_poly_2] += Time.now.to_i + Time.now.usec.to_f / 10 ** 6 - temp
			return a, b, c, d
		end

		def next_d
			d = @d + 4
			if d < ANT.primes_list.last
				plist = ANT.primes_list
				(d..plist.last).each_prime do |p|
					return p if p[1] == 1 and ANT.kronecker_symbol(@n, p) == 1
				end
				d += 4
			end

			loop do
				return d if ANT.kronecker_symbol(@n, d) == 1 and ANT.power(@n, d >> 1, d) == 1
				d += 4
			end
		end

		def sieve(a, b, c, d)
			a2 = a << 1
			lo = -(b / a2) - @sieve_range + 1

			sieve = Array.new(@sieve_range_2, 0)

temp = Time.now.to_i + Time.now.usec.to_f / 10 ** 6
			# Sieve by 2
	#		0.upto(@sieve_range_2 - 1) do |i|
	#			count = 1
	#			count += 1 while sieve[i][2][count] == 0
	#			sieve[i][1] += @factor_base_log[1] * count
	#		end

			# Sieve by 3, 5, 7, 11, ...
	#		2.upto(@factor_base_size - 1) do |i|
			4.upto(@factor_base_size - 1) do |i|
				p = @factor_base[i]
				a_inverse = ANT.extended_lehmer_gcd(a2, p ** @power_limit[i])[0]
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
						sieve[j] += factor_base_log_i
					end

					t = pe - sqrt
					s = ((t - b) * a_inverse - lo) % pe
					s.step(@sieve_range_2 - 1, pe) do |j|
						sieve[j] += factor_base_log_i
					end

					e += 1
				end
			end
@@proc_time[:sieve_a] += Time.now.to_i + Time.now.usec.to_f / 10 ** 6 - temp

temp = Time.now.to_i + Time.now.usec.to_f / 10 ** 6
			# select trial division target
			td_target = []
			sieve.each.with_index do |sum_of_log, idx|
				if @closenuf < sum_of_log
					x = idx + lo
					t = a * x
					td_target.push([(t << 1) + b, (t + b) * x + c])
				end
			end
@@proc_time[:sieve_slct] += Time.now.to_i + Time.now.usec.to_f / 10 ** 6 - temp

			# trial division on factor base
			factorization = []
			factorization_2 = []
			r_list = []
			r_list_2 = []
			big_prime_sup = []
			big_prime_sup_2 = []
temp = Time.now.to_i + Time.now.usec.to_f / 10 ** 6
			td_target.each do |r, s|
				f, re = trial_division_on_factor_base(s, @factor_base)
				if 1 == re
					f[1] += 2
					factorization.push(f)
					r_list.push(r)
					big_prime_sup.push(d)
#				else
#					unless @big_prime[re]
#						@big_prime[re] = [f, r, d]
#					else
#						r_list_2.push(r * @big_prime[re][1])
#						t = @big_prime[re][2]
#						t = (d == t) ? a : d * t
#						big_prime_sup_2.push(re * t)
#						t = @big_prime[re][0].zip(f).map{|e1, e2| e1 + e2}
#						t[1] += 4
#						factorization_2.push(t)
#					end
				end
			end
@@proc_time[:sieve_td] += Time.now.to_i + Time.now.usec.to_f / 10 ** 6 - temp

			if factorization_2.empty?
				return factorization, r_list, big_prime_sup
			end

			r_list += r_list_2
			big_prime_sup += big_prime_sup_2
			factorization += factorization_2

			return factorization, r_list, big_prime_sup
		end

		def gaussian_elimination(m)
			elim_start = @matrix_left.size
			temp = Array.new(m.size)
			m.size.times do |i|
				temp[i] = @mask
				@mask <<= 1
			end
			rslt = @matrix_right += temp
			m = @matrix_left += m.map{|row| row.reverse_each.map{|i| i[0]}}

			height = m.size
			width = @factor_base_size

			i = 0
			width.times do |j|
				unless @check_list[j]
					# Find non-zero entry
					row = nil
					elim_start.upto(height - 1) do |i2|
						if 1 == m[i2][j]
							row = i2
							break
						end
					end
					next unless row

					@check_list[j] = row

					# Swap?
					if i < row
						m.insert(i, m.delete_at(row))
						rslt.insert(i, rslt.delete_at(row))
					end

					elim_start += 1
				end

				# Eliminate
				m_i = m[i]
				(row ? (row + 1) : elim_start).upto(height - 1) do |i2|
					next if m[i2][j] == 0

					m_i2 = m[i2]
					(j + 1).upto(width - 1) do |j2|
						m_i2[j2] ^= 1 if 1 == m_i[j2]
					end
					rslt[i2] ^= rslt[i]
				end

				i += 1
			end

			t = height - i
			m.pop(t)
			return rslt.pop(t)
		end

		def trial_division_on_factor_base(n, factor_base)
			factor = Array.new(@factor_base_size, 0)
			if n < 0
				factor[0] = 1
				n = -n
			end

			div_count = 1
			div_count += 1 while n[div_count] == 0
			factor[1] = div_count
			n >>= div_count

			i = 2
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
	end

	def mpqs(n, thread_num = ANT::THREAD_NUM)
		mpqs = MPQS.new(n, thread_num)
		return mpqs.find_factor
	end
end
