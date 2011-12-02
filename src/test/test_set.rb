require 'test/unit'
require 'abst'

class TC_Set < Test::Unit::TestCase
	def test_add
		# sortable
		assert_equal([1, 2, 3].to_set, [1, 3].to_set.add(2))
		assert_equal([2, 1, 2, 3].to_set, [1, 2, 3].to_set.add(2))
		assert_equal([3, 1, 2, 3, 5].to_set, [5, 2, 3, 1].to_set.add(2))

		# unsortable
		assert_equal([1, 2, 3].to_set(false), [1, 3].to_set.add(2))
		assert_equal([2, 1, 2, 3].to_set(false), [1, 2, 3].to_set.add(2))
		assert_equal([3, 1, 2, 3, 5].to_set, [5, 2, 3, 1].to_set(false).add(2))
	end
end
