require 'test/unit'
require 'ant'

class TC_Rational < Test::Unit::TestCase
	def test_to_rds
		assert_equal("0.5", Rational(1, 2).to_rds)
		assert_equal("0.(3)", Rational(1, 3).to_rds)
		assert_equal("0.25", Rational(1, 4).to_rds)
		assert_equal("0.2", Rational(1, 5).to_rds)
		assert_equal("0.1(6)", Rational(1, 6).to_rds)
		assert_equal("0.(142857)", Rational(1, 7).to_rds)
		assert_equal("0.125", Rational(1, 8).to_rds)
		assert_equal("0.(1)", Rational(1, 9).to_rds)
		assert_equal("0.1", Rational(1, 10).to_rds)
		assert_equal("0.1005e3", Rational(201, 2).to_rds(10))
		assert_equal("0.(10)", Rational(2, 3).to_rds(2))
	end

	def test_to_ds
		assert_equal("0.5", Rational(1, 2).to_ds)
		assert_equal("0." + "3" * 15, Rational(1, 3).to_ds(15))
		assert_equal("0.25", Rational(1, 4).to_ds)
		assert_equal("0.2", Rational(1, 5).to_ds)
		assert_equal("0.1" + "6" * 31, Rational(1, 6).to_ds(32))
		assert_equal("0." + "142857" * 10, Rational(1, 7).to_ds(60, 10))
		assert_equal("0.125", Rational(1, 8).to_ds)
		assert_equal("0.11111", Rational(1, 9).to_ds(5))
		assert_equal("0.1", Rational(1, 10).to_ds)
		assert_equal("0.1005e3", Rational(201, 2).to_ds(10))
		assert_equal("0." + "10" * 15, Rational(2, 3).to_ds(30, 2))
	end
end
