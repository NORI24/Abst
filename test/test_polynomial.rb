require 'test/unit'
require 'ant'

class TC_Polynomial < Test::Unit::TestCase
	def test_Polynomial
		polynomial = ANT::Polynomial(Rational)
		assert_equal("Rational", polynomial.coef_class.name)

		poly = polynomial.new([1, Rational(2, 7), 3])
		assert_equal([1, Rational(2, 7), 3], poly.to_a)

		poly = ANT::Polynomial(Rational, [3, 5])
		assert_equal([3, 5], poly.to_a)
	end

	def test_zero
		polynomial = ANT::Polynomial(Rational)
		assert_equal([0], polynomial.zero.to_a)
	end

	def test_one
		polynomial = ANT::Polynomial(Rational)
		assert_equal(polynomial.new([1]), polynomial.one)
	end

	def test_add
		polynomial = ANT::Polynomial(Integer)
		poly1 = polynomial.new([2, 3, 4])
		poly2 = polynomial.new([-3, 12, -4])
		poly3 = polynomial.new([-3, 12])
		assert_equal([-1, 15], (poly1 + poly2).to_a)
		assert_equal([-1, 15, 4], (poly1 + poly3).to_a)
		assert_equal([4, 3, 4], (poly1 + 2).to_a)
	end

	def test_sub
		polynomial = ANT::Polynomial(Integer)

		poly1 = polynomial.new([2, 3, 4])
		poly2 = polynomial.new([-3, 12, 4])
		poly3 = polynomial.new([-3, 12])
		assert_equal([5, -9], (poly1 - poly2).to_a)
		assert_equal([5, -9, 4], (poly1 - poly3).to_a)
		assert_equal([0, 3, 4], (poly1 - 2).to_a)
	end

	def test_mul
		polynomial = ANT::Polynomial(Integer)
		poly1 = polynomial.new([2, 3, 4])
		poly2 = polynomial.new([-3, 12, -4])
		expect = polynomial.new([-6, 15, 16, 36, -16])

		assert_equal(expect, (poly1 * poly2))
	end

	def test_divmod
		polynomial = ANT::Polynomial(Integer)

		poly1 = polynomial.new([1, 2, 3])
		poly2 = polynomial.new([1])
		q, r = poly1.divmod(poly2)
		assert_equal(poly1, q)
		assert_equal(polynomial.zero, r)

		poly3 = polynomial.new([4, 5, 0, 1])
		poly4 = polynomial.new([3, 3, 1])
		q, r = poly3.divmod(poly4)
		assert_equal(polynomial.new([-3, 1]), q)
		assert_equal(polynomial.new([13, 11]), r)
	end

	def test_eq
		polynomial = ANT::Polynomial(Integer)
		poly1 = polynomial.new([2, 3, 4])
		poly2 = polynomial.new([2, 3, 4])
		poly3 = polynomial.new([-3, 12, -4])

		assert_equal(true, poly1 == poly2)
		assert_equal(false, poly1 == poly3)
	end

	def test_degree
		polynomial = ANT::Polynomial(Integer)
		poly = polynomial.new([2, 3, 4, 0])
		assert_equal(2, poly.degree)
	end

	def test_lc
		polynomial = ANT::Polynomial(Integer)
		poly = polynomial.new([2, 3, 4])
		assert_equal(4, poly.lc)
	end

	def test_eval
		polynomial = ANT::Polynomial(Integer)
		poly = polynomial.new([2, -3, 4])
		assert_equal(3, poly.eval(1))
		assert_equal(12, poly.eval(2))
	end

	def test_to_a
		polynomial = ANT::Polynomial(Integer)
		poly = polynomial.new([2, -3, 4])
		assert_equal([2, -3, 4], poly.to_a)
	end
end
