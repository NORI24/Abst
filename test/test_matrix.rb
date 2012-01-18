require 'test/unit'
require 'ant'

class TC_Matrix < Test::Unit::TestCase
	def test_Matrix
		matrix = ANT::Matrix(Rational, 2, 3)
		assert_equal("Rational", matrix.coef_class.name)
		assert_equal(2, matrix.height)
		assert_equal(3, matrix.width)

		m = [[3, 5, 1], [9, 2, 3]]
		assert_equal(m, ANT::Matrix(Rational, m).to_a)
	end

	def test_add
		matrix = ANT::Matrix(Rational, 2, 3)
		m1 = matrix.new([[2, 3, 2], [4, 5, -7]])
		m2 = matrix.new([[3, 1, 4], [2, -3, 1]])

		assert_equal([[5, 4, 6], [6, 2, -6]], (m1 + m2).to_a)
	end

	def test_sub
		matrix = ANT::Matrix(Rational, 2, 3)
		m1 = matrix.new([[2, 3, 2], [4, 5, -7]])
		m2 = matrix.new([[3, 1, 4], [2, -3, 1]])

		assert_equal([[-1, 2, -2], [2, 8, -8]], (m1 - m2).to_a)
	end
end

class TC_SquareMatrix < Test::Unit::TestCase
	def test_trace
		matrix = ANT::Matrix(Rational, 2, 2)
		m = matrix.new([[2, 3], [4, 5]])

		assert_equal(7, m.trace)
	end
end
