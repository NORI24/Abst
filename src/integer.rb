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

	# Test whether a given number is a square number or not
	# Param::  positive integer n
	# Return:: root(n) if n is square else false
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
end
