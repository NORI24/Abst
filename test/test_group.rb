require 'minitest/autorun'
require 'abst'

class TC_Group < MiniTest::Test
	def test_element_order
		f_7 = Abst.residue_class_field(7 * Integer)
		assert_equal(6, Abst.element_order(f_7.new(3), 6))
	end
end
