require 'test/unit'
require 'abst'

class TC_Set < Test::Unit::TestCase
	def test_add
		assert_equal([1, 2, 3].to_set, [1, 3].to_set.add(2))
		assert_equal([1, 2, 3].to_set, [1, 2, 3].to_set.add(2))
		assert_equal([1, 2, 3, 3, 5].to_set, [5, 2, 3, 1].to_set.add(2))
	end
end
