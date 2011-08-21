require 'test/unit'
require 'abst'

class TC_Fundamental < Test::Unit::TestCase
	def test_right_left_power
		assert_equal(1, right_left_power(5, 0))
		assert_equal(1024, right_left_power(2, 10))
		assert_equal(24, right_left_power(2, 10, 100))
		# Float
		assert_equal(1.0 / 1024, right_left_power(2.0, -10))
		# Rational
		assert_equal(Rational(1024, 59049), right_left_power(Rational(2, 3), 10))
		assert_equal(Rational(59049, 1024), right_left_power(Rational(2, 3), -10))
		# Complex
		assert_equal(Complex('1/32i'), right_left_power(Complex('1/2+1/2i'), 10))
		assert_equal(Complex('-32i'), right_left_power(Complex('1/2+1/2i'), -10))
	end

	def test_left_right_power
		assert_equal(1, left_right_power(5, 0))
		assert_equal(1024, left_right_power(2, 10))
		assert_equal(24, left_right_power(2, 10, 100))
		# Float
		assert_equal(1.0 / 1024, left_right_power(2.0, -10))
		# Rational
		assert_equal(Rational(1024, 59049), left_right_power(Rational(2, 3), 10))
		assert_equal(Rational(59049, 1024), left_right_power(Rational(2, 3), -10))
		# Complex
		assert_equal(Complex('1/32i'), left_right_power(Complex('1/2+1/2i'), 10))
		assert_equal(Complex('-32i'), left_right_power(Complex('1/2+1/2i'), -10))
	end

	def test_left_right_base2k_power
		assert_equal(1, left_right_base2k_power(5, 0))
		assert_equal(1024, left_right_base2k_power(2, 10))
		assert_equal(24, left_right_base2k_power(2, 10, 100))
		assert_equal(24, left_right_base2k_power(2, 10, 100, 1))
		assert_equal(8212890625, left_right_base2k_power(5, 2 ** 100, 10 ** 10))
		# Float
		assert_equal(1.0 / 1024, left_right_base2k_power(2.0, -10))
		assert_equal(1.0 / 1024, left_right_base2k_power(2.0, -10, nil, 2))
		# Rational
		assert_equal(Rational(1024, 59049), left_right_base2k_power(Rational(2, 3), 10))
		assert_equal(Rational(59049, 1024), left_right_base2k_power(Rational(2, 3), -10))
		# Complex
		assert_equal(Complex('1/32i'), left_right_base2k_power(Complex('1/2+1/2i'), 10))
		assert_equal(Complex('-32i'), left_right_base2k_power(Complex('1/2+1/2i'), -10))
	end

	def test_gcd
		assert_equal(1, gcd(3, 4))
		assert_equal(7, gcd(14, 21))
		assert_equal(2, gcd(150, 376))
		assert_equal(32, gcd(1024, 32))
	end

	def test_lehmer_gcd
		assert_equal(7, lehmer_gcd(14, 21))
		assert_equal(4294967311, lehmer_gcd(4294967311 * 2, 4294967311 * 3))

		10.times do
			a = rand(1 << (BASE_BYTE << 5))
			b = rand(1 << (BASE_BYTE << 5))
			assert_equal(gcd(a, b), lehmer_gcd(a, b))
		end
	end

	def test_binary_gcd
		assert_equal(1, binary_gcd(3, 4))
		assert_equal(7, binary_gcd(14, 21))
		assert_equal(2, binary_gcd(150, 376))
		assert_equal(32, binary_gcd(1024, 32))

		10.times do
			a = rand(1 << (BASE_BYTE << 5))
			b = rand(1 << (BASE_BYTE << 5))
			assert_equal(gcd(a, b), binary_gcd(a, b))
		end
	end

	def test_extended_gcd
		assert_equal([-1, 1, 1], extended_gcd(3, 4))
		assert_equal([-1, 1, 7], extended_gcd(14, 21))
		assert_equal([-5, 2, 2], extended_gcd(150, 376))
		assert_equal([0, 1, 32], extended_gcd(1024, 32))

		10.times do
			a = rand(10 ** 15)
			b = rand(10 ** 15)

			u, v, d = extended_gcd(a, b)
			assert_equal(gcd(a, b), d)
			assert_equal(d, a * u + b * v)
		end
	end

	def test_extended_lehmer_gcd
		assert_equal([-1, 1, 1], extended_lehmer_gcd(3, 4))
		assert_equal([-1, 1, 7], extended_lehmer_gcd(14, 21))
		assert_equal([-5, 2, 2], extended_lehmer_gcd(150, 376))
		assert_equal([0, 1, 32], extended_lehmer_gcd(1024, 32))

		10.times do
			a = rand(1 << (BASE_BYTE << 5))
			b = rand(1 << (BASE_BYTE << 5))

			u, v, d = extended_lehmer_gcd(a, b)
			assert_equal(gcd(a, b), d)
			assert_equal(d, a * u + b * v)
		end
	end

	def test_isqrt
		assert_equal(1, isqrt(1))
		assert_equal(1, isqrt(2))
		assert_equal(1, isqrt(3))
		assert_equal(2, isqrt(4))
		assert_equal(3, isqrt(15))
		assert_equal(4, isqrt(16))
		assert_equal(7, isqrt(50))
		assert_equal(9, isqrt(97))
		assert_equal(1553171, isqrt(2412342342347))

		10.times do
			n = rand(10 ** 20) + 1
			sroot = isqrt(n)
			assert(sroot ** 2 <= n && n < (sroot + 1) ** 2)
		end
	end

	def test_iroot
		assert_equal(1, iroot(1, 2))
		assert_equal(1, iroot(2, 2))
		assert_equal(1, iroot(3, 2))
		assert_equal(2, iroot(4, 2))

		assert_equal(1, iroot(1, 3))
		assert_equal(1, iroot(2, 3))
		assert_equal(1, iroot(7, 3))
		assert_equal(2, iroot(8, 3))
		assert_equal(2, iroot(26, 3))
		assert_equal(3, iroot(27, 3))

		assert_equal([1, 1], iroot(1, 4, true))
		assert_equal([1, 1], iroot(15, 4, true))
		assert_equal([2, 16], iroot(16, 4, true))
		assert_equal([2, 16], iroot(80, 4, true))
		assert_equal(3, iroot(81, 4))

		10.times do
			n = rand(10 ** 20) + 1
			pow = rand(40) + 1
			proot = iroot(n, pow)
			assert(proot ** pow <= n && n < (proot + 1) ** pow)
		end
	end

	def test_ilog2
		assert_equal(0, ilog2(1))
		assert_equal(1, ilog2(2))
		assert_equal(1, ilog2(3))
		assert_equal(2, ilog2(4))
		assert_equal(2, ilog2(5))
		assert_equal(7, ilog2(2 ** 8 - 1))
		assert_equal(8, ilog2(2 ** 8))
		assert_equal(31, ilog2(2 ** 32 - 1))
		assert_equal(32, ilog2(2 ** 32))
		assert_equal(63, ilog2(2 ** 64 - 1))
		assert_equal(64, ilog2(2 ** 64))
	end

	def test_powers_of_2
		list = [1, 2, 4, 8, 16, 32, 64, 128, 256]

		assert_equal(list, powers_of_2[0..8])
		assert_equal(BASE_BYTE * 8, powers_of_2.size)
	end
end
