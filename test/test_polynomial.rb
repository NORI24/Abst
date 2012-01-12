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
end
