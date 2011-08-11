# return gcd(a, b)
# a and b are member of Euclidean domain
def gcd(a, b)
	until b.zero?
		a, b = b, a % b
	end

	return a
end
