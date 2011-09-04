# Right-Left Binary Power
# Param::  group element g
#          integer n
#          Euclidean domain element mod
# Return:: g ** n % mod
def right_left_power(g, n, mod = nil)
	rslt = g.class.one
	return rslt if 0 == n

	if n < 0
		n = -n
		g **= (-1)
	end

	g %= mod if mod

	loop do
		rslt *= g if n.odd?
		rslt %= mod if mod

		n >>= 1
		break if 0 == n

		g *= g
		g %= mod if mod
	end

	return rslt
end

# Left-Right Binary Power
# Param::  group element g
#          integer n
#          Euclidean domain element mod
# Return:: g ** n % mod
def left_right_power(g, n, mod = nil)
	return g.class.one if 0 == n

	if n < 0
		n = -n
		g **= (-1)
	end

	g %= mod if mod
	e = ilog2(n)

	rslt = g
	while 0 != e
		e -= 1

		rslt *= rslt
		rslt %= mod if mod

		if 1 == n[e]
			rslt *= g
			rslt %= mod if mod
		end
	end

	return rslt
end
alias power left_right_power

# Left-Right Base 2**k Power
# Param::  group element g
#          integer n
#          Euclidean domain element mod
#          base bit size k
# Return:: g ** n % mod
def left_right_base2k_power(g, n, mod = nil, k = nil)
	rslt = g.class.one
	return rslt if 0 == n

	# Initialize
	if n < 0
		n = -n
		g **= (-1)
	end

	g %= mod if mod

	unless k
		e = ilog2(n)
		optim = [0, 8, 24, 69, 196, 538, 1433, 3714]

		if e <= optim.last
			k = Bisect.bisect_left(optim, e)
		else
			k = optim.size
			k += 1 until e <= k * (k + 1) * (1 << (k << 1)) / ((1 << (k + 1)) - k - 2)
		end
	end

	# convert n into base 2**k
	digits = []
	mask = (1 << k) - 1
	until 0 == n
		digits.unshift(n & mask)
		n >>= k
	end

	# Precomputations
	z_powers = [nil, g]
	g_square = g * g
	g_square %= mod if mod
	3.step((1 << k) - 1, 2) do |i|
		z_powers[i] = z_powers[i - 2] * g_square
		z_powers[i] %= mod if mod
	end

	digits.each do |a|
		# Multiply
		if 0 == a
			k.times do
				rslt *= rslt
				rslt %= mod if mod
			end
		else
			t = 0
			t += 1 while 0 == a[t]
			a >>= t if 0 < t

			(k - t).times do
				rslt *= rslt
				rslt %= mod if mod
			end
			rslt *= z_powers[a]
			rslt %= mod if mod
			t.times do
				rslt *= rslt
				rslt %= mod if mod
			end
		end
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

# Param::  non-negative integer a, b
# Return:: gcd of a and b
def lehmer_gcd(a, b)
	a, b = b, a if a < b

	until 0 == b
		return gcd(a, b) if b.instance_of?(Fixnum)

		# Get most significant digits of a and b
		shift_size = (a < b ? b : a).bit_size - FIXNUM_BIT_SIZE
		a_ = a >> shift_size
		b_ = b >> shift_size

		_A = 1
		_B = 0	# a_ == msd(a) * _A + msd(b) * _B
		_C = 0
		_D = 1	# b_ == msd(a) * _C + msd(b) * _D

		# Always
		# a_ + _B <= msd(a * _A + b * _B) < a_ + _A AND
		# b_ + _C <= msd(a * _C + b * _D) < a_ + _D
		# OR
		# a_ + _B > msd(a * _A + b * _B) >= a_ + _A AND
		# b_ + _C > msd(a * _C + b * _D) >= a_ + _D

		# Test quotient
		until 0 == b_ + _C or 0 == b_ + _D
			q1 = (a_ + _A) / (b_ + _C)
			q2 = (a_ + _B) / (b_ + _D)
			break if q1 != q2

			# Euclidean step
			_A, _C = _C, _A - q1 * _C
			_B, _D = _D, _B - q1 * _D
			a_, b_ = b_, a_ - q1 * b_
		end

		# Multi-precision step
		if 0 == _B
			a, b = b, a % b
		else
			a, b = a * _A + b * _B, a * _C + b * _D
		end
	end

	return a
end

# Binary GCD
# Param::  non-negative integer a, b
# Return:: gcd of a and b
def binary_gcd(a, b)
	a, b = b, a if a < b
	return a if 0 == b

	# Reduce size once
	a, b = b, a % b
	return a if 0 == b

	# Compute powers of 2
	k = 0
	k += 1 while 0 == a[k] and 0 == b[k]
	if 0 < k
		a >>= k
		b >>= k
	end

	# Remove initial power of 2
	a >>= 1 while a.even?
	b >>= 1 while b.even?

	loop do
		# Subtract (Here a and b are both odd.)
		t = (a - b) >> 1
		return a << k if 0 == t

		t >>= 1 while t.even?

		if 0 < t
			a = t
		else
			b = -t
		end
	end
end

# Param::  a and b are member of a Euclidean domain
# Return:: (u, v, d) s.t. a*u + b*v = gcd(a, b) = d
def extended_gcd(a, b)
	u0 = a.class.one
	u1 = a.class.zero

	return u0, u1, a if b.zero?

	d0 = a	# d0 = a * u0 + b * v0
	d1 = b	# d1 = a * u1 + b * v1

	loop do
		q, r = d0.divmod(d1)

		return u1, (d1 - a * u1) / b, d1 if r.zero?

		d0, d1 = d1, r
		u0, u1 = u1, u0 - q * u1
	end
end

# Param::  non-negative integer a, b
# Return:: (u, v, d) s.t. a*u + b*v = gcd(a, b) = d
def extended_lehmer_gcd(a, b)
	d0 = a
	u0 = 1	# d0 = a * u0 + b * v0
	d1 = b
	u1 = 0	# d1 = a * u1 + b * v1

	loop do
		if d1.instance_of?(Fixnum)
			_u, _v, d = extended_gcd(d0, d1)

			# here
			# d == _u * d0 + _v * d1
			# d0 == u0 * a + v0 * b
			# d1 == u1 * a + v1 * b

			u = _u * u0 + _v * u1
			v = (d - u * a) / b

			return u, v, d
		end

		# Get most significant digits of d0 and d1
		shift_size = (d0 < d1 ? d1 : d0).bit_size - FIXNUM_BIT_SIZE
		a_ = d0 >> shift_size
		b_ = d1 >> shift_size

		# Initialize (Here a_ and b_ are next value of d0, d1)
		_A = 1
		_B = 0	# a_ == msd(d0) * _A + msd(d1) * _B
		_C = 0
		_D = 1	# b_ == msd(d0) * _C + msd(d1) * _D

		# Test Quotient
		until 0 == b_ + _C or 0 == b_ + _D
			q1 = (a_ + _B) / (b_ + _D)
			q2 = (a_ + _A) / (b_ + _C)
			break if q1 != q2

			# Euclidean step
			_A, _C = _C, _A - q1 * _C
			_B, _D = _D, _B - q1 * _D
			a_, b_ = b_, a_ - q1 * b_
		end

		# Multi-precision step
		if 0 == _B
			q, r = d0.divmod(d1)
			d0, d1  = d1, r
			u0, u1 = u1, u0 - q * u1
		else
			d0, d1  = d0 * _A + d1 * _B, d0 * _C + d1 * _D
			u0, u1 =u0 *  _A + u1 * _B, u0 * _C + u1 * _D
		end
	end
end

# Param::  non-negative integer a, b
# Return:: (u, v, d) s.t. a*u + b*v = gcd(a, b) = d
def extended_binary_gcd(a, b)
	if a < b
		a, b = b, a
		exchange_flag_1 = true
	end

	if 0 == b
		return 0, 1, a if exchange_flag_1
		return 1, 0, a
	end

	# Reduce size once
	_Q, r = a.divmod(b)
	if 0 == r
		return 1, 0, b if exchange_flag_1
		return 0, 1, b
	end
	a, b = b, r

	# Compute power of 2
	_K = 0
	_K += 1 while 0 == a[_K] and 0 == b[_K]
	if 0 < _K
		a >>= _K
		b >>= _K
	end

	if b.even?
		a, b = b, a
		exchange_flag_2 = true
	end

	# Initialize
	u = 1
	d = a	# d == a * u + b * v, (v = 0)
	u_ = 0
	d_ = b	# d_ == a * u_ + b * v_, (v_ = 1)

	# Remove intial power of 2
	while d.even?
		d >>= 1
		u += b if u.odd?
		u >>= 1
	end

	loop do
		# Substract
		next_u = u - u_
		next_d = d - d_		# next_d == a * next_u + b * next_v
		next_u += b if next_u < 0

		# Finish?
		break if 0 == next_d

		# Remove powers of 2
		while next_d.even?
			next_d >>= 1
			next_u += b if next_u.odd?
			next_u >>= 1
		end

		# Loop
		if 0 < next_d
			u = next_u
			d = next_d
		else
			u_ = b - next_u
			d_ = -next_d
		end
	end

	# Terminate
	v = (d - a * u) / b

	u, v = v, u if exchange_flag_2
	d <<= _K
	u, v = v, u - v * _Q
	u, v = v, u if exchange_flag_1

	return u, v, d
end

# Chinese Remainder Theorem using Algorithm 1.3.11 of [CCANT]
# Param::  array of pair integer s.t. [[x_1, m_1], [x_2, m_2], ... , [x_k, m_k]]
#          m_i are pairwise coprime
# Return:: integer x s.t. x = x_i (mod m_i) for all i
#          and 0 <= x < m_1 * m_2 * ... * m_k
# Example: chinese_remainder_theorem([(1,2),(2,3),(3,5)]) return 23
def chinese_remainder_theorem(list)
	raise NotImplementedError
end

# Chinese Remainder Theorem using Algorithm 1.3.12 of [CCANT]
# Param::  array of pair integer s.t. [[x_1, m_1], [x_2, m_2], ... , [x_k, m_k]]
#          m_i are pairwise coprime
# Return:: integer x s.t. x = x_i (mod m_i) for all i
#          and 0 <= x < m_1 * m_2 * ... * m_k
# Example: chinese_remainder_theorem([(1,2),(2,3),(3,5)]) return 23
def inductive_chinese_remainder_theorem(list)
	raise NotImplementedError
end
alias crt inductive_chinese_remainder_theorem

# Param::
# Return::
def continued_fraction(a, b, a_, b_)
	raise NotImplementedError
end

# Param::
# Return::
def kronecker_symbol(n, m)
	raise NotImplementedError
end

# Param::
# Return::
def mod_square_root(n, p)
	raise NotImplementedError
end

# Param::
# Return::
def cornacchia()
	raise NotImplementedError
end

# Param::
# Return::
def modified_cornacchia()
	raise NotImplementedError
end

# Param::
# Return::
def root_mod_p
	raise NotImplementedError
end

# Integer Square Root
# Param::  positive integer n
# Return:: integer part of the square root of n
#  i.e. the number m s.t. m ** 2 <= n < (m + 1) ** 2
def isqrt(n)
	# #
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
#         i.e. the number m s.t. m ** pow <= n < (m + 1) ** pow
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

# Param::
# Return::
def prime_power?(n)
	raise NotImplementedError
end

# Param::
# Return::
def power_detection(n)
	raise NotImplementedError
end

# Param::  positive integer n
# Return:: integer e s.t. 2 ** e <= n < 2 ** (e + 1)
def ilog2(n)
	bits = (n.size - BASE_BYTE) << 3
	return bits + Bisect.bisect_right(powers_of_2, n >> bits) - 1
end

$powers_of_2 = nil
# Return:: array power of 2 s.t. [1, 2, 4, 8, 16, 32, ...]
def powers_of_2
	unless $powers_of_2
		$powers_of_2 = [1]
		((BASE_BYTE << 3) - 1).times do |i|
			$powers_of_2[i + 1] = $powers_of_2[i] << 1
		end
	end

	return $powers_of_2
end


def continued_fraction_of_sqrt(m)
	if r = m.square?
		return [r, []]
	end

	rslt = [isqrt(m), []]

	a = 1
	_B = b = -rslt[0]
	c = 1

	loop do
		# inverse
		a, b, c = a * c, -b * c, a**2 * m - b**2

		# reduction
		t = gcd(gcd(a, b), c)
		a /= t
		b /= t
		c /= t

		t = (isqrt(m * a ** 2) + b) / c
		rslt[1].push(t)
		b -= c * t

		return rslt if 1 == a and _B == b and 1 == c
	end

end
