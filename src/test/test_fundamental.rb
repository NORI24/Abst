require 'test/unit'
require 'abst'

class TC_Fundamental < Test::Unit::TestCase
	def test_power
		test_cases = [
			[5, 0, 1],
			[2, 10, 1024],
			[2.0, -10, 1.0/1024],
		]

		test_cases.each do |g, n, expect|
			rslt = power(g, n)

			assert_equal(expect, rslt)
		end
	end

	def test_gcd
		test_cases = [
			[3, 4, 1],
			[14, 21, 7],
		]

		test_cases.each do |a, b, g|
			assert_equal(g, gcd(a, b))
		end
	end

	def test_binary_gcd
		test_cases = [
			[3, 4, 1],
			[14, 21, 7],
			[1024, 32, 32],
		]

		test_cases.each do |a, b, g|
			assert_equal(g, binary_gcd(a, b))
		end
	end

	def test_isqrt
		tc = [1, 2, 3, 13, 16, 50, 97, 2412342342347]

		tc.each do |i|
			sroot = isqrt(i)
			assert(sroot ** 2 <= i && i < (sroot + 1) ** 2)
		end
	end

	def test_square?
		assert_equal(1, square?(1))
		assert_equal(false, square?(2))
		assert_equal(false, square?(3))
		assert_equal(2, square?(4))
		assert_equal(false, square?(5))
		assert_equal(13, square?(169))
		assert_equal(false, square?(42342341))
	end
end
