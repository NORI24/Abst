# Param::  group element g
#          Integer n
#          Euclidean domain element mod
# Return:: g ** n % mod
def power(g, n, mod = nil)
	return g.class.one if 0 == n

	if n < 0
		n = -n
		g = g ** (-1)
	end

	g %= mod if mod
	e = ilog2(n)

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
	a >>= 1 while a.even?
	b >>= 1 while b.even?

	loop do
		# 4. Subtract (Here a and b are both odd.)
		t = (a - b) >> 1
		return 2 ** k * a if 0 == t

		t >>= 1 if t.even?

		if 0 < t
			a = t
		else
			b = -t
		end
	end
end

def extended_gcd(a, b)
	raise NotImplementedError
end

def extended_binary_gcd(a, b)
	raise NotImplementedError
end

def crt(n, mod)
	raise NotImplementedError
end

def continued_fraction(a, b, a_, b_)
	raise NotImplementedError
end

def kronecker_symbol(n, m)
	raise NotImplementedError
end

# Integer Square Root
# Param::  positive integer n
# Return:: integer part of the square root of n
#  i.e. the number m s.t. m ** 2 <= n < (m + 1) ** 2
def isqrt(n)
	x = n

	loop do
		# Newtonian step
		next_x = (x + n / x) >> 1

		break if x <= next_x

		x = next_x
	end

	return x
end

# Integer Power Root
# Param::  positive integer n
#          positive integer pow
# Return:: integer part of the power root of n
#  i.e. the number m s.t. m ** pow <= n < (m + 1) ** pow
def iroot(n, pow, return_power = false)
	# get integer e s.t. (2 ** (e - 1)) ** pow <= n < (2 ** e) ** pow
	e = ilog2(n) / pow + 1		# == Rational(n.bit_size, pow).ceil

	x = 1 << e					# == 2 ** e
	z = nil
	q = n >> (e * (pow - 1))	# == n / (x ** (pow -  1))

	loop do
		# Newtonian step
		x += (q - x) / pow
		z = x ** (pow - 1)
		q = n / z

		break if x <= q
	end

	return x, x * z if return_power
	return x
end

def prime_power?(n)
	raise NotImplementedError
end

def power_detection(n)
	raise NotImplementedError
end

def ilog2(n)
	bits = (n.size - BASE_BYTE) << 3
	return bits + Bisect.bisect_right(powers_of_2, n >> bits) - 1
end

$powers_of_2 = nil
def powers_of_2
	unless $powers_of_2
		$powers_of_2 = [1]
		((BASE_BYTE << 3) - 1).times do |i|
			$powers_of_2[i + 1] = $powers_of_2[i] << 1
		end
	end

	return $powers_of_2
end
