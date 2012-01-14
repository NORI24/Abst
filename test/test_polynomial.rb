require 'test/unit'
require 'ant'

class TC_Polynomial < Test::Unit::TestCase
	def test_Polynomial
		polynomial = ANT.Polynomial(Rational)
		assert_equal("Rational", polynomial.coef_class.name)

		poly = polynomial.new([1, Rational(2, 7), 3])
		assert_equal([1, Rational(2, 7), 3], poly.coef)

		poly = ANT.Polynomial(Rational, [3, 5])
		assert_equal([3, 5], poly.coef)
	end

	def test_zero
		polynomial = ANT.Polynomial(Rational)
		assert_equal([0], polynomial.zero.coef)
	end

	def test_one
		polynomial = ANT.Polynomial(Rational)
		assert_equal([1], polynomial.one.coef)
	end

	def test_add
		polynomial = ANT.Polynomial(Integer)

		poly1 = polynomial.new([2, 3, 4])
		poly2 = polynomial.new([-3, 12, -4])
		assert_equal([-1, 15], (poly1 + poly2).coef)

		poly1 = polynomial.new([2, 3, 4])
		poly2 = polynomial.new([-3, 12])
		assert_equal([-1, 15, 4], (poly1 + poly2).coef)

		assert_equal([4, 3, 4], (poly1 + 2).coef)
	end

	def test_sub
		polynomial = ANT.Polynomial(Integer)

		poly1 = polynomial.new([2, 3, 4])
		poly2 = polynomial.new([-3, 12, 4])
		assert_equal([5, -9], (poly1 - poly2).coef)

		poly1 = polynomial.new([2, 3, 4])
		poly2 = polynomial.new([-3, 12])
		assert_equal([5, -9, 4], (poly1 - poly2).coef)

		assert_equal([0, 3, 4], (poly1 - 2).coef)
	end

#	def test_sub
#
#	end
#
#	def test_mul
#
#	end
#
#	def test_div
#
#	end

	def test_degree
		polynomial = ANT.Polynomial(Integer)
		poly = polynomial.new([2, 3, 4])
		assert_equal(2, poly.degree)
	end
end
