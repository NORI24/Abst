def mpqs(n, factor_base_size = nil, sieve_range = nil)
	# multiplier
	multiplier = 1
#	multiplier = n & 7
#	n *= multiplier if 1 < multiplier

	# Initialize
# #decide factor_base_size and sieve_range
	sqrt = isqrt(n)
	range_limit = isqrt(n << 1) - sqrt
	sieve_range = range_limit if range_limit < sieve_range

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

	# Basic sieve
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
		(1..max).each do |e|
			sqrt = mod_sqrt(n, p, e)
			[sqrt, p ** e - sqrt].each do |t|
				s = (t - lo) % p ** e
				s.step((sieve_range << 1) - 1, p ** e) do |j|
					sieve[j][1] += factor_base_log[i]
				end
			end
		end
end
	end

	# MPQS


	# Gaussian elimination
	target = Math.log(n) / 2 + Math.log(sieve_range)
	closenuf = 1.5 * Math.log(factor_base.last)
	sieve = sieve.select{|i| (i[1] - target).abs < closenuf}
p sieve.size
	return false if sieve.size <= factor_base_size

	factorization = []
	r_list = []
	big_prime = {}
	big_prime_sup = []
	sieve.map do |r, z, s, l|
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
				big_prime[re][0]
				factorization.push(big_prime[re][0].zip(f).map{|a, b| a + b})
			end
		end
		break if factor_base_size + 10 < factorization.size
	end
p factorization.size
	return false if factorization.size <= factor_base_size

	rslt = gaussian_elimination(factorization.map(&:reverse))

	rslt.each do |row|
		x = y = 1
		f = Array.new(factor_base_size, 0)
		row.each.with_index do |b, i|
			next if b == 0
			x = x * r_list[i] % n
			f = f.zip(factorization[i]).map{|a, b| a + b}
if big_prime_sup[i]
	y = y * big_prime_sup[i] % n
end
		end

		factor_base_size.times do |i|
			y = y * power(factor_base[i], f[i] >> 1, n) % n
		end

raise "ERROR" unless 0 == (x ** 2 - y ** 2) % n
		z = gcd(x - y, n)
		if 1 < z and z < n and z != multiplier
			q, r = z.divmod(multiplier)
			return (0 == r) ? q : z
		end
	end

	return false
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
