require 'test/unit'
require 'abst'

class TC_Vector < Test::Unit::TestCase
	def test_Vector
		vector = Vector(Rational, 3)
		assert_equal("Rational", vector.coef_class.name)
		assert_equal(3, vector.size)

		v = Vector(Rational, [2, 3, 4])
		assert_equal([2, 3, 4], v)
	end

	def test_add
		vector = Vector(Integer, 4)
		v1 = vector.new([3, 4, 5, 6])
		v2 = vector.new([1, 1, 1, 3])

		assert_equal([4, 5, 6, 9], v1 + v2)
	end

	def test_sub
		vector = Vector(Integer, 4)
		v1 = vector.new([3, 4, 5, 6])
		v2 = vector.new([1, 1, 1, 3])

		assert_equal([2, 3, 4, 3], v1 - v2)
	end

	def test_squared_length
		vector = Vector(Integer, 4)
		v = vector.new([3, 4, 5, 6])

		assert_equal(9 + 16 + 25 + 36, v.squared_length)
	end
end
