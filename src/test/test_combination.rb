require 'test/unit'
require 'abst'

class TC_Combination < Test::Unit::TestCase
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

	def test_binomial
		assert_equal(1, binomial(1, 1))
		assert_equal(1, binomial(1, 0))
		assert_equal(45, binomial(10, 2))
		assert_equal(120, binomial(10, 7))
	end
end
