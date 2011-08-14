require 'test/unit'
require 'abst'

class TC_Combination < Test::Unit::TestCase
	def test_factorial
		assert_equal(1, factorial(0))
		assert_equal(1, factorial(1))
		assert_equal(2, factorial(2))
		assert_equal(6, factorial(3))
		assert_equal(24, factorial(4))
		assert_equal(120, factorial(5))
		assert_equal(720, factorial(6))
	end

	def test_binomial
		assert_equal(1, binomial(1, 1))
		assert_equal(1, binomial(1, 0))
		assert_equal(45, binomial(10, 2))
		assert_equal(120, binomial(10, 7))
	end
end
