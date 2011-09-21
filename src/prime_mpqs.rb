def mpqs(n, factor_base_size = nil, sieve_range = nil)
	# Initialize

	# Select factor base
	factor_base = [-1, 2]
	i = 1
	plist = primes_list
	loop do
		p = plist[i]
		if 1 == kronecker_symbol(n, p)
			factor_base.push(p)
			break if factor_base_size <= factor_base.size
		end
		i += 1
	end

	sqrt_list = factor_base.map{|p| mod_sqrt(n, p)}

	# Sieve
	sieve = Array.new(sieve_range << 1)
	sqrt = isqrt(n)
	sqrt_half = sqrt >> 1
	sieve_range = sqrt_half if sqrt_half < sieve_range
	((sqrt - sieve_range)...(sqrt + sieve_range)).each.with_index do |r, i|
		t = (r ** 2 - n)
		p t
		sieve[i] = Math.log(t.abs)
	end

	# Gaussian elimination

	return factor_base, sqrt_list
end
