class MPQS
	def initialize(n, factor_base_size = nil, sieve_range = nil)
		@n = n
		@factor_base_size = factor_base_size
		@sieve_range = sieve_range
	end

	def mpqs
		n = @n
		factor_base_size = @factor_base_size
		sieve_range = @sieve_range

		# multiplier
		multiplier = 1
	#	multiplier = n & 7
	#	n *= multiplier if 1 < multiplier

		# Initialize
		# #decide factor_base_size and sieve_range
		sqrt = isqrt(n)
		range_limit = isqrt(n << 1) - sqrt

		# Select factor base
		factor_base = [-1, 2]
		(3..INFINITY).each_prime do |p|
	#		next if multiplier == p
			if multiplier == p or 1 == kronecker_symbol(n, p)
				factor_base.push(p)
				break if factor_base_size <= factor_base.size
			end
		end
		factor_base_log = [nil] + factor_base[1..-1].map{|p| Math.log(p)}
		mod_sqrt_cache = Array.new(factor_base_size - 1)
		(2...factor_base_size).each do |i|
			p = factor_base[i]
			mod_sqrt_cache[i] = []
			max = (factor_base_log.last / factor_base_log[i]).ceil
			(1..max).each do |e|
				mod_sqrt_cache[i][e] = mod_sqrt(n, p, e)
			end
		end

		@factor_base = factor_base
		@factor_base_log = factor_base_log
		@mod_sqrt_cache = mod_sqrt_cache

		# MPQS
		factorization = []
		r_list = []
		big_prime_sup = []

		a = next_prime(isqrt(n << 1) / sieve_range)
		loop_num = 1
		a_list = []
		loop do
			# parallelization
			threads = Array.new(MAX_THREAD)

			MAX_THREAD.times do |i|
				a = next_prime(a) until b = mod_sqrt(n, a)

				threads[i] = Thread.new(a) do |a|
					mpqs_sieve(a, b)
				end

				a = next_prime(a)
			end

			MAX_THREAD.times do |i|
				_a, f, r, b = threads[i].value

				if 1 < f.size
					a_list.unshift(_a)
					factorization.map!{|row| [0] + row}
					f.map!{|row| row.insert(1, *([0] * (loop_num - 1)))} if 1 < loop_num
					factorization += f
					r_list += r
					big_prime_sup += b
					break if factor_base.size + loop_num + 9 < factorization.size

					loop_num += 1
				end
			end

			break if factor_base.size + loop_num + 9 < factorization.size

#p [_a, f, r, b]
#sleep 0.3
		end
		factor_base = a_list + factor_base

		# Gaussian elimination
		rslt = gaussian_elimination(factorization.map(&:reverse))

		rslt.each do |row|
			x = y = 1
			f = Array.new(factor_base_size + loop_num, 0)
			row.each.with_index do |b, i|
				next if b == 0
				x = x * r_list[i] % n
				f = f.zip(factorization[i]).map{|a, b| a + b}
				y = y * big_prime_sup[i] % n if big_prime_sup[i]
			end

			(factor_base_size + loop_num).times do |i|
				y = y * power(factor_base[i], f[i] >> 1, n) % n
			end

			z = lehmer_gcd(x - y, n)
			raise if 1 == z and 1 == lehmer_gcd(x + y, n)# #

			if 1 < z and z < n and z != multiplier
				q, r = z.divmod(multiplier)
				return (0 == r) ? q : z
			end
		end

		return false
	end

	def mpqs_sieve(a, b)
		n = @n
		factor_base_size = @factor_base_size
		sieve_range = @sieve_range
		factor_base = @factor_base
		factor_base_log = @factor_base_log

		lo = -b / a - sieve_range + 1
		hi = -b / a + sieve_range

		sieve = Array.new(sieve_range << 1)
		(lo..hi).each.with_index do |r, i|
			t = a * r + b
			sieve[i] = [t, 0, (t ** 2 - n) / a]
		end

		# 2
		s = sieve[0][0].odd? ? 0 : 1
		s.step((sieve_range << 1) - 1, 2) do |i|
			count = 1
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
	#	s.step((sieve_range << 1) - 1, p) do |j|
	#		sieve[j][1] += factor_base_log[i]
	#	end
	#else
			max = (factor_base_log.last / factor_base_log[i]).ceil
			pe = 1
			(1..max).each do |e|
				pe *= p
				sqrt = @mod_sqrt_cache[i][e]
				[sqrt, pe - sqrt].each do |t|
					s = ((t - b) * a_inverse - lo) % pe
					s.step((sieve_range << 1) - 1, pe) do |j|
						sieve[j][1] += factor_base_log[i]
					end
				end
			end
	#end
		end

		# trial division on factor base
		target = Math.log((a * sieve_range) ** 2 - n) - Math.log(a)
		closenuf = 1.5 * Math.log(factor_base.last)
		sieve = sieve.select{|i| (i[1] - target).abs < closenuf}
#p sieve.size

		factorization = []
		r_list = []
		big_prime = {}
		big_prime_sup = []
		sieve.map do |r, z, s|
			f, re = trial_division_on_factor_base(s, factor_base)
			if 1 == re
				factorization.push([1] + f)
				r_list.push(r)
			else
	if re < 2000 ** 1.5
				unless big_prime[re]
					big_prime[re] = [f, r]
				else
					r_list.push(r * big_prime[re][1] - n)
					big_prime_sup[factorization.size] = re
					factorization.push([2] + big_prime[re][0].zip(f).map{|a, b| a + b})
				end
	end
			end
			break if factor_base_size + 10 < factorization.size
		end

#p factorization.size
		big_prime_sup += [nil] * (factorization.size - big_prime_sup.size)
		return a, factorization, r_list, big_prime_sup
	end

	def qs_sieve
		#	# Basic sieve
		sieve = Array.new(sieve_range << 1)
		lo = sqrt - sieve_range + 1
		hi = sqrt + sieve_range
		s = (lo - 1) ** 2 - n
		diff = (lo << 1) - 1
		(lo..hi).each.with_index do |r, i|
			s += diff
			t = (0 < s) ? s : -s
			diff += 2
			sieve[i] = [r, 0, s]
		end

		# 2
		s = sieve[0][0].odd? ? 0 : 1
		s.step((sieve_range << 1) - 1, 2) do |i|
			count = 1
			count += 1 while sieve[i][2][count] == 0
			sieve[i][1] += factor_base_log[1] * count
		end

		# 3, ...
		(2...factor_base_size).each do |i|
			p = factor_base[i]
	if p == multiplier
		t = 0
		s = (t - lo) % p
		s.step((sieve_range << 1) - 1, p) do |j|
			sieve[j][1] += factor_base_log[i]
		end
	else
			max = (factor_base_log.last / factor_base_log[i]).ceil
			pe = 1
			(1..max).each do |e|
				pe *= p
				sqrt = mod_sqrt(n, p, e)
				[sqrt, pe - sqrt].each do |t|
					s = (t - lo) % pe
					s.step((sieve_range << 1) - 1, pe) do |j|
						sieve[j][1] += factor_base_log[i]
					end
				end
			end
	end
		end
		# trial division on factor base
		target = Math.log(n) / 2 + Math.log(sieve_range)
		closenuf = 1.5 * Math.log(factor_base.last)
		sieve = sieve.select{|i| (i[1] - target).abs < closenuf}
	p sieve.size
		return false if sieve.size <= factor_base_size

		factorization = []
		r_list = []
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
					r_list.push(r * big_prime[re][1] - n)
					big_prime_sup[factorization.size] = re
					factorization.push(big_prime[re][0].zip(f).map{|a, b| a + b})
				end
			end
			break if factor_base_size + 10 < factorization.size
		end
	p factorization.size
		return false if factorization.size <= factor_base_size
	end

	def gaussian_elimination(m)
		m.map!{|row| row.map{|i| i[0]}.reverse}

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

			# Eliminate
			((j + 1)...height).each do |i|
				next if m[i][j] == 0

				((j + 1)...width).each do |j2|
					m[i][j2] ^= 1 if 1 == m[j][j2]
				end
				height.times do |j2|
					rslt[i][j2] ^= 1 if 1 == rslt[j][j2]
				end
			end
		end

		return rslt.pop(height - width)
	end

	def trial_division_on_factor_base(n, factor_base)
		factor = Array.new(factor_base.size, 0)
		if n < 0
			factor[0] = 1
			n = -n
		end

		factor_base[1..-1].each.with_index do |d, i|
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

				factor[i + 1] = div_count
			end
		end

		return factor, n
	end
end

def mpqs(n, factor_base_size = nil, sieve_range = nil)
	mpqs = MPQS.new(n, factor_base_size, sieve_range)
	return mpqs.mpqs
end

__END__
a ‚Ìeliminate ‚Ü‚Å•À—ñ‰»‚ÉŠÜ‚ß‚é
