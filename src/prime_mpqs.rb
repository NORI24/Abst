def mpqs(n, factor_base_size = nil, sieve_range = nil)
	# Initialize
# #decide factor_base_size and sieve_range

	# Select factor base
	factor_base = [-1, 2]
	(3..INFINITY).each_prime do |p|
		if 1 == kronecker_symbol(n, p)
			factor_base.push(p)
			break if factor_base_size <= factor_base.size
		end
	end

	# Sieve
	sqrt = isqrt(n)
	sqrt_half = sqrt >> 1
	sieve_range = sqrt_half if sqrt_half < sieve_range
	sieve = Array.new(sieve_range << 1)
	lo = sqrt - sieve_range
	hi = sqrt + sieve_range
	(lo...hi).each.with_index do |r, i|
		t = r ** 2 - n
		factorization = Array.new(factor_base_size, 0)
		sieve[i] = [r, t.abs, factorization]
	end

	# -1
	(0..sieve_range).each do |i|
		sieve[i][2][0] = 1
	end

	# 2
	s = sieve[0][1].even? ? 0 : 1
	s.step((sieve_range << 1) - 1, 2) do |i|
		count = 1
		count += 1 while sieve[i][1][count] == 0
		sieve[i][2][1] = count
		sieve[i][1] >>= count
	end

	# 3, ...
	(2...factor_base.size).each do |i|
		p = factor_base[i]
		(1..5).each do |e|
			sqrt = mod_sqrt(n, p, e)
			[sqrt, p ** e - sqrt].each do |t|
				s = (t - lo) % p ** e
				s.step((sieve_range << 1) - 1, p ** e) do |j|
					sieve[j][2][i] += 1
					sieve[j][1] /= p
				end
			end
		end
	end

	# Gaussian elimination
	sieve = sieve.select{|i| 1 == i[1]}
	return false if sieve.size <= factor_base.size

	factorization = sieve.map(&:last).map(&:dup)
	rslt = gaussian_elimination(factorization)

	rslt.each do |row|
		x = 1
		f = Array.new(factor_base_size, 0)
		row.each.with_index do |b, i|
			next if b == 0
			x = x * sieve[i][0] % n
			f = f.zip(sieve[i][2]).map{|a, b| a + b}
		end

		y = 1
		factor_base_size.times do |i|
			y = y * power(factor_base[i], f[i] >> 1, n) % n
		end

		z = gcd(x - y, n)
		return z if 1 < z and z < n
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
				m[i][j2] ^= m[j][j2]
			end
			height.times do |j2|
				rslt[i][j2] ^= rslt[j][j2]
			end
		end
	end

	return rslt.pop(height - width)
end
