class Integer
	# Param::  non-negative integer n
	# Return:: factorial n!
	def factorial
		return (2..self).inject(1) {|r, i| r * i}
	end
end

def factorial(n)
	return n.factorial
end

def binomial(n, r)
	r = [r, n - r].min

	return 1 if 0 == r

	rslt = n
	(2..r).each do |i|
		rslt = rslt * (n - i + 1) / i
	end

	return rslt
end
