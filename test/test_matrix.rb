require 'minitest/autorun'
require 'abst'

class TC_Matrix < MiniTest::Test
	def test_Matrix
		matrix = Abst::Matrix(Rational, 2, 3)
		assert_equal("Rational", matrix.coef_class.name)
		assert_equal(2, matrix.height)
		assert_equal(3, matrix.width)

		m = [[3, 5, 1], [9, 2, 3]]
		assert_equal(m, Abst::Matrix(Rational, m).to_a)
	end

	def test_each
		matrix = Abst::Matrix(Rational, 2, 2)
		m = matrix.new([[3, 5], [1, 2]])
		assert_equal([3, 5, 1, 2], m.each.to_a)
	end

	def test_add
		matrix = Abst::Matrix(Rational, 2, 3)
		m1 = matrix.new([[2, 3, 2], [4, 5, -7]])
		m2 = matrix.new([[3, 1, 4], [2, -3, 1]])

		assert_equal([[5, 4, 6], [6, 2, -6]], (m1 + m2).to_a)
	end

	def test_sub
		matrix = Abst::Matrix(Rational, 2, 3)
		m1 = matrix.new([[2, 3, 2], [4, 5, -7]])
		m2 = matrix.new([[3, 1, 4], [2, -3, 1]])

		assert_equal([[-1, 2, -2], [2, 8, -8]], (m1 - m2).to_a)
	end

	def test_solve
		assert_equal([2].to_v, [[2, 4]].to_m.solve)
		assert_equal([-5.5, 6.0].to_v, [[2, 3, 7], [4, 5, 8]].to_m.solve)
		assert_equal([-22, 20].to_v, [[4, 5, 12], [2, 3, 16]].to_m.solve)
		assert_equal([-2, 2, 1].to_v, [[1, 1, 1, 1], [1, 2, 3, 5], [2, 4, 8, 12]].to_m.solve)
		assert_equal(nil, [[1, 2, 3, 12], [4, 5, 6, 13], [7, 8, 9, 14]].to_m.solve)
	end
end

class TC_SquareMatrix < MiniTest::Test
	def test_trace
		matrix = Abst::Matrix(Rational, 2, 2)
		m = matrix.new([[2, 3], [4, 5]])

		assert_equal(7, m.trace)
	end

#	def test_inverse
#		assert_equal([[-2, 1], [Rational(3, 2), Rational(-1, 2)]].to_m, [[1, 2], [3, 4]].to_m.inverse)
#	end
end
