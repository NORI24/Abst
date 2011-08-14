# Param::  g is a element of a group
#          n is a Integer
#          mod is a element of a Euclidean domain
# Return:: gcd of a and b
def power(g, n, mod = nil)
	return g.class.one if 0 == n

	if n < 0
		n = -n
		g = g ** (-1)
	end

	g %= mod if mod

	# get integer e s.t. 2^e <= n < 2^(e+1)
	e = Math.log2(n).floor

	rslt = g
	while 0 != e
		e -= 1
		rslt **= 2
		rslt *= g if 1 == n[e]
		rslt %= mod if mod
	end

	return rslt
end

# GCD
# Param::  a and b are member of a Euclidean domain
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

# Integer Square Root
# Param::  positive integer n
# Return:: integer part of the square root of n
#  i.e. the number m s.t. m^2 <= n < (m+1)^2
def integer_square_root(n)
	x = n

	loop do
		# Newtonian step
		y = (x + n / x) >> 1

		break if x <= y

		x = y
	end

	return x
end
