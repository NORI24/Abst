require 'test/unit'
require 'ant'

class TC_Matrix < Test::Unit::TestCase
	def test_Matrix
		matrix = ANT.Matrix(Rational, 2, 2)
		assert_equal("Rational", matrix.coef_class.name)
		assert_equal(2, matrix.height)
		assert_equal(2, matrix.width)

		m = ANT.Matrix(Rational, [[3, 5], [9, 2]])
		assert_equal([[3, 5], [9, 2]], m)
	end

	def test_add
		matrix = ANT.Matrix(Rational, 2, 2)
		m1 = matrix.new([[2, 3], [4, 5]])
		m2 = matrix.new([[3, 1], [2, -3]])

		assert_equal([[5, 4], [6, 2]], m1 + m2)
	end

	def test_sub
		matrix = ANT.Matrix(Rational, 2, 2)
		m1 = matrix.new([[2, 3], [4, 5]])
		m2 = matrix.new([[3, 1], [2, -3]])

		assert_equal([[-1, 2], [2, 8]], m1 - m2)
	end

	def test_trace
		matrix = ANT.Matrix(Rational, 2, 2)
		m = matrix.new([[2, 3], [4, 5]])

		assert_equal(7, m.trace)
	end
end
