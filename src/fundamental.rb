# GCD
# Param::  a and b are member of Euclidean domain
# Return:: gcd of a and b
def gcd(a, b)
	until b.zero?
		a, b = b, a % b
	end

	return a
end

# Binary GCD
# Param::  non-negative integer a, b
# Return:: gcd of a and b
def binary_gcd(a, b)
	a, b = b, a if a < b

	return a if (0 == b)

	# 1. Reduce size once
	a, b = b, a % b

	return a if (0 == b)

	# 2. Compute powers of 2
	k = 0
	while (0 == a[k] and 0 == b[k])
		k += 1
	end
	a >>= k
	b >>= k

	# 3. Remove initial power of 2
	a >>= 1 while 0 == a[0]
	b >>= 1 while 0 == b[0]

	loop do
		# 4. Subtract (Here a and b are both odd.)
		t = (a - b) >> 1
		return 2 ** k * a if 0 == t

		t >>= 1 if 0 == t[0]

		if 0 < t
			a = t
		else
			b = -t
		end
	end
end
