require 'test/unit'
require 'abst'

class TC_Rational < Test::Unit::TestCase
	def test_to_decimal_s
		assert_equal("0.5", Rational(1, 2).to_decimal_s)
		assert_equal("0.(3)", Rational(1, 3).to_decimal_s)
		assert_equal("0.25", Rational(1, 4).to_decimal_s)
		assert_equal("0.2", Rational(1, 5).to_decimal_s)
		assert_equal("0.1(6)", Rational(1, 6).to_decimal_s)
		assert_equal("0.(142857)", Rational(1, 7).to_decimal_s)
		assert_equal("0.125", Rational(1, 8).to_decimal_s)
		assert_equal("0.(1)", Rational(1, 9).to_decimal_s)
		assert_equal("0.1", Rational(1, 10).to_decimal_s)
		assert_equal("0.1005e3", Rational(201, 2).to_decimal_s(10))

		assert_equal("0.(10)", Rational(2, 3).to_decimal_s(2))
	end
end
