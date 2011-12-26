require 'test/unit'
require 'ant'

class TC_Array < Test::Unit::TestCase
	def test_each_coefficient
		assert_equal([[0, 0], [0, 1], [1, 0], [1, 1]].sort,
			[1, 1].each_coefficient.to_a.sort)
	end
end
