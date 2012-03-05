require 'minitest/unit'
require 'minitest/autorun'
require 'abst'

class TC_Vector < MiniTest::Unit::TestCase
	def test_Vector
		vector = Abst::Vector(Rational, 3)
		assert_equal("Rational", vector.coef_class.name)
		assert_equal(3, vector.size)

		v = Abst::Vector(Rational, [2, 3, 4])
		assert_equal([2, 3, 4], v.to_a)
	end

	def test_add
		vector = Abst::Vector(Integer, 4)
		v1 = vector.new([3, 4, 5, 6])
		v2 = vector.new([1, 1, 1, 3])

		assert_equal([4, 5, 6, 9], (v1 + v2).to_a)
	end

	def test_sub
		vector = Abst::Vector(Integer, 4)
		v1 = vector.new([3, 4, 5, 6])
		v2 = vector.new([1, 1, 1, 3])

		assert_equal([2, 3, 4, 3], (v1 - v2).to_a)
	end

	def test_squared_length
		vector = Abst::Vector(Integer, 4)
		v = vector.new([3, 4, 5, 6])

		assert_equal(9 + 16 + 25 + 36, v.squared_length)
	end
end
