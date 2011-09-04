class Integer
	def self.one
		return 1
	end

	def self.zero
		return 0
	end

	def bit_size
		return ilog2(self) + 1
	end

	# Return:: formatted string
	def to_fs
		return self.to_s.gsub(/(?<=\d)(?=(\d\d\d)+$)/, ' ')
	end

	# Param::  non-negative integer self
	# Return:: factorial self!
	def factorial
		return (2..self).inject(1) {|r, i| r * i}
	end

	def combination(r)
		r = self - r if self - r < r

		if r <= 0
			return 1 if 0 == r
			return 0
		end

		rslt = self
		(2..r).each do |i|
			rslt = rslt * (self - i + 1) / i
		end

		return rslt
	end
	alias :C :combination

	# Triangle numbers are generated by the formula, T_n = n * (n + 1) / 2.
	# The first ten triangle numbers are:
	#     1, 3, 6, 10, 15, 21, 28, 36, 45, 55, ...
	# Return:: integer n s.t. self == T_n if exist else false
	def triangle?
		return false unless r = ((self << 3) + 1).square?
		return false unless (r - 1).even?

		return (r - 1) >> 1
	end

	# Test whether self is a square number or not
	# Param::  positive integer self
	# Return:: root(self) if self is square else false
	def square?
		check = {
			11=>[true, true, false, true, true, true, false, false, false, true, false],
			63=>[true, true, false, false, true, false, false, true, false, true, false, false, false, false, false, false, true, false, true, false, false, false, true, false, false, true, false, false, true, false, false, false, false, false, false, false, true, true, false, false, false, false, false, true, false, false, true, false, false, true, false, false, false, false, false, false, false, false, true,false, false, false, false],
			64=>[true, true, false, false, true, false, false, false, false, true, false, false, false, false, false, false, true, true, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, true, false, false, false, false, true, false, false, false, false, false, false,false, true, false, false, false, false, false, false, false, true, false, false, false, false, false, false],
			65=>[true, true, false, false, true, false, false, false, false, true, true, false, false, false, true, false, true, false, false, false, false, false, false, false, false, true, true, false, false, true, true, false, false, false, false, true, true, false, false, true, true, false, false, false, false, false, false, false, false, true, false, true, false, false, false, true, true, false, false, false, false, true, false, false, true]
		}

		# 64
		t = self & 63
		return false unless check[64][t]

		r = self % 45045	# == 63 * 65 * 11
		[63, 65, 11].each do |c|
			return false unless check[c][r % c]
		end

		q = isqrt(self)
		return false if q ** 2 != self

		return q
	end

	# #
	# Param::  positive integer self
	# Return:: true if self is squarefree, false otherwise
	def squarefree?
		n = self
		if n.even?
			return false if 0 == n[1]
			n >>= 1
		end

		return true if self <= 3
		return false if self.square?

		pl = primes_list

		# trial division
		limit = isqrt(n)
		i = 1
		(1...pl.size).each do |i|
			d = pl[i]
			return true if limit < d

			if n % d == 0
				n /= d
				return false if n % d == 0
				limit = isqrt(n)
			end
		end

		d = pl.last + 2
		loop do
			return true if limit < d

			if n % d == 0
				n /= d
				return false if n % d == 0
				limit = isqrt(n)
			end

			d += 2
		end
	end

	# Pentagonal numbers are generated by the formula, P_n = n * (3 * n - 1) / 2.
	# The first ten pentagonal numbers are:
	#     1, 5, 12, 22, 35, 51, 70, 92, 117, 145, ...
	# Return:: integer n s.t. self == P_n if exist else false
	def pentagonal?
		return false unless r = (24 * self + 1).square?

		q, r = (1 + r).divmod(6)
		return false unless 0 == r

		return q
	end

	# Hexagonal numbers are generated by the formula, H_n = n * (2 * n - 1)
	# The first ten hexagonal numbers are:
	#     1, 6, 15, 28, 45, 66, 91, 120, 153, 190, ...
	# Return:: integer n s.t. self == H_n if exist else false
	def hexagonal?
		return false unless r = ((self << 3) + 1).square?
		return false unless 0 == (1 + r) & 3

		return (1 + r) >> 2
	end

	# Heptagonal numbers are generated by the formula, P7_n = n * (5 * n - 3) / 2
	# The first ten heptagonal numbers are:
	#     1, 7, 18, 34, 55
	# Return:: integer n s.t. self == P7_n if exist else false
	def heptagonal?
		return false unless r = (self * 40 + 9).square?

		q, r = (3 + r).divmod(10)
		return false unless 0 == r

		return q
	end

	# Octagonal numbers are generated by the formula, P8_n = n * (3 * n - 2)
	# The first ten octagonal numbers are:
	#     1, 8, 21, 40, 65, ...
	# Return:: integer n s.t. self == P7_n if exist else false
	def octagonal?
		return false unless r = (self * 3 + 1).square?

		q, r = (1 + r).divmod(3)
		return false unless 0 == r

		return q
	end
end
