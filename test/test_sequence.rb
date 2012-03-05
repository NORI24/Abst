require 'minitest/unit'
require 'minitest/autorun'
require 'abst'

class TC_Fundamental < MiniTest::Unit::TestCase
	def test_fibonacci
		assert_equal(1, Abst.fibonacci(1))
		assert_equal(1, Abst.fibonacci(2))
		assert_equal(2, Abst.fibonacci(3))
		assert_equal(3, Abst.fibonacci(4))
		assert_equal(5, Abst.fibonacci(5))
		assert_equal(12586269025, Abst.fibonacci(50))
		assert_equal(354224848179261915075, Abst.fibonacci(100))
	end

	def test_triangle
		assert_equal(1, Abst.triangle(1))
		assert_equal(3, Abst.triangle(2))
		assert_equal(6, Abst.triangle(3))
		assert_equal(10, Abst.triangle(4))
		assert_equal(15, Abst.triangle(5))
	end

	def test_pentagonal
		assert_equal(1, Abst.pentagonal(1))
		assert_equal(5, Abst.pentagonal(2))
		assert_equal(12, Abst.pentagonal(3))
		assert_equal(22, Abst.pentagonal(4))
		assert_equal(35, Abst.pentagonal(5))
	end

	def test_hexagonal
		assert_equal(1, Abst.hexagonal(1))
		assert_equal(6, Abst.hexagonal(2))
		assert_equal(15, Abst.hexagonal(3))
		assert_equal(28, Abst.hexagonal(4))
		assert_equal(45, Abst.hexagonal(5))
	end

	def test_heptagonal
		assert_equal(1, Abst.heptagonal(1))
		assert_equal(7, Abst.heptagonal(2))
		assert_equal(18, Abst.heptagonal(3))
		assert_equal(34, Abst.heptagonal(4))
		assert_equal(55, Abst.heptagonal(5))
	end

	def test_octagonal
		assert_equal(1, Abst.octagonal(1))
		assert_equal(8, Abst.octagonal(2))
		assert_equal(21, Abst.octagonal(3))
		assert_equal(40, Abst.octagonal(4))
		assert_equal(65, Abst.octagonal(5))
	end
end
