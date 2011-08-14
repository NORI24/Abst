require 'test/unit'
require 'abst'

class TC_Combination < Test::Unit::TestCase
	def test_binomial
		assert_equal(1, binomial(1, 1))
		assert_equal(1, binomial(1, 0))
		assert_equal(45, binomial(10, 2))
		assert_equal(120, binomial(10, 7))
	end
end
