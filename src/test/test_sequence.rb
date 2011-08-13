require 'test/unit'
require 'abst'

class TC_Fundamental < Test::Unit::TestCase
	def test_fibonacci
		assert_equal(1, fibonacci(1))
		assert_equal(1, fibonacci(2))
		assert_equal(2, fibonacci(3))
		assert_equal(3, fibonacci(4))
		assert_equal(5, fibonacci(5))
		assert_equal(12586269025, fibonacci(50))
		assert_equal(354224848179261915075, fibonacci(100))
	end
end
