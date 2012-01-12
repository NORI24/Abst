require 'test/unit'
require 'ant'

class TC_Polynomial < Test::Unit::TestCase
	def test_Polynomial
		polynomial = ANT.Polynomial(Rational)
		assert_equal("Rational", polynomial.coef_class.name)

		poly = ANT.Polynomial(Rational, [3, 5])
		assert_equal([3, 5], poly.coef)
	end
end
