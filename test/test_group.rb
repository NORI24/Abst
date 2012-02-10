require 'minitest/unit'
require 'minitest/autorun'
require 'ant'

class TC_Group < MiniTest::Unit::TestCase
	def test_element_order
		f_7 = residue_class_field(7 * Integer)
		assert_equal(6, element_order(f_7.new(3), 6))
	end
end
