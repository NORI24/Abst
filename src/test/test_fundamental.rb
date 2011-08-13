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

	def test_factorial
		test_cases = [
			[0, 1],
			[1, 1],
			[2, 2],
			[3, 6],
			[4, 24],
			[5, 120],
			[6, 720],
		]

		test_cases.each do |n, expect|
			rslt = factorial(n)

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

	def test_integer_square_root
		tc = [1, 2, 3, 13, 16, 50, 97, 2412342342347]

		tc.each do |i|
			sroot = integer_square_root(i)
			assert(sroot ** 2 <= i && i < (sroot + 1) ** 2)
		end
	end
end
