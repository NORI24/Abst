def mpqs(n)
	raise NotImplementedError

	# Initialize
	factor_base_size = 30

	# Select factor base
	factor_base = []
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


	return factor_base, sqrt_list
end
