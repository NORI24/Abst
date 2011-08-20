def binomial(n, r)
	r = [r, n - r].min

	return 1 if 0 == r

	rslt = n
	(2..r).each do |i|
		rslt = rslt * (n - i + 1) / i
	end

	return rslt
end
