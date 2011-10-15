require 'test/unit'
require 'abst'

class TC_Bisect < Test::Unit::TestCase
	def test_bisect_left
		list = [1, 2, 3, 3, 4, 6]
		assert_equal(1, Bisect.bisect_left(list, 2))
		assert_equal(2, Bisect.bisect_left(list, 3))
		assert_equal(4, Bisect.bisect_left(list, 4))
		assert_equal(5, Bisect.bisect_left(list, 5))
		assert_equal(5, Bisect.bisect_left(list, 6))
		
		list = [[1, 2], [2, 3], [3, 5], [4, 7], [5, 11]]
		assert_equal(1, Bisect.bisect_left(list, 3){|a, b| a[1] <=> b})
		assert_equal(2, Bisect.bisect_left(list, 4){|a, b| a[1] <=> b})
		assert_equal(2, Bisect.bisect_left(list, 5){|a, b| a[1] <=> b})
	end

	def test_bisect_right
		list = [1, 2, 3, 3, 4, 6]
		assert_equal(2, Bisect.bisect_right(list, 2))
		assert_equal(4, Bisect.bisect_right(list, 3))
		assert_equal(5, Bisect.bisect_right(list, 4))
		assert_equal(5, Bisect.bisect_right(list, 5))
		assert_equal(6, Bisect.bisect_right(list, 6))
		
		list = [[1, 2], [2, 3], [3, 5], [4, 7], [5, 11]]
		assert_equal(2, Bisect.bisect_right(list, 3){|a, b| a[1] <=> b})
		assert_equal(2, Bisect.bisect_right(list, 4){|a, b| a[1] <=> b})
		assert_equal(3, Bisect.bisect_right(list, 5){|a, b| a[1] <=> b})
	end
end
