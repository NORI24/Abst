require 'minitest/autorun'
require 'abst'

class TC_Array < MiniTest::Test
	def test_each_coefficient
		assert_equal([[0, 0], [0, 1], [1, 0], [1, 1]].sort,
			[1, 1].each_coefficient.to_a.sort)
	end
end
