require 'minitest/unit'
require 'minitest/autorun'
require 'ant'

class TC_Array < MiniTest::Unit::TestCase
	def test_each_coefficient
		assert_equal([[0, 0], [0, 1], [1, 0], [1, 1]].sort,
			[1, 1].each_coefficient.to_a.sort)
	end
end
