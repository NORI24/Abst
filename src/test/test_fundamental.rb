require 'test/unit'
require 'abst'

class TC_Fundamental < Test::Unit::TestCase
	def test_right_left_power
		assert_equal(1, right_left_power(5, 0))
		assert_equal(1024, right_left_power(2, 10))
		assert_equal(24, right_left_power(2, 10, 100))
		assert_equal(1.0 / 1024, right_left_power(2.0, -10))
	end

	def test_left_right_power
		assert_equal(1, left_right_power(5, 0))
		assert_equal(1024, left_right_power(2, 10))
		assert_equal(24, left_right_power(2, 10, 100))
		assert_equal(1.0 / 1024, left_right_power(2.0, -10))
	end

	def test_left_right_base2k_power
		assert_equal(1, left_right_base2k_power(5, 0))
		assert_equal(1024, left_right_base2k_power(2, 10))
		assert_equal(24, left_right_base2k_power(2, 10, 100))
		assert_equal(24, left_right_base2k_power(2, 10, 100, 1))
		assert_equal(8212890625, left_right_base2k_power(5, 2 ** 100, 10 ** 10))
		assert_equal(1.0 / 1024, left_right_base2k_power(2.0, -10))
		assert_equal(1.0 / 1024, left_right_base2k_power(2.0, -10, nil, 2))
	end

	def test_gcd
		assert_equal(1, gcd(3, 4))
		assert_equal(7, gcd(14, 21))
		assert_equal(2, binary_gcd(150, 376))
		assert_equal(32, binary_gcd(1024, 32))
	end

	def test_lehmer_gcd
	end

	def test_binary_gcd
		assert_equal(1, binary_gcd(3, 4))
		assert_equal(7, binary_gcd(14, 21))
		assert_equal(2, binary_gcd(150, 376))
		assert_equal(32, binary_gcd(1024, 32))
	end

	def test_isqrt
		tc = [1, 2, 3, 13, 16, 50, 97, 2412342342347]

		tc.each do |i|
			sroot = isqrt(i)
			assert(sroot ** 2 <= i && i < (sroot + 1) ** 2)
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
			n = rand(10 ** 10) + 1
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
