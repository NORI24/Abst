require 'test/unit'
require 'ant'

class TC_Fundamental < Test::Unit::TestCase
	def test_fibonacci
		assert_equal(1, ANT.fibonacci(1))
		assert_equal(1, ANT.fibonacci(2))
		assert_equal(2, ANT.fibonacci(3))
		assert_equal(3, ANT.fibonacci(4))
		assert_equal(5, ANT.fibonacci(5))
		assert_equal(12586269025, ANT.fibonacci(50))
		assert_equal(354224848179261915075, ANT.fibonacci(100))
	end

	def test_triangle
		assert_equal(1, ANT.triangle(1))
		assert_equal(3, ANT.triangle(2))
		assert_equal(6, ANT.triangle(3))
		assert_equal(10, ANT.triangle(4))
		assert_equal(15, ANT.triangle(5))
	end

	def test_pentagonal
		assert_equal(1, ANT.pentagonal(1))
		assert_equal(5, ANT.pentagonal(2))
		assert_equal(12, ANT.pentagonal(3))
		assert_equal(22, ANT.pentagonal(4))
		assert_equal(35, ANT.pentagonal(5))
	end

	def test_hexagonal
		assert_equal(1, ANT.hexagonal(1))
		assert_equal(6, ANT.hexagonal(2))
		assert_equal(15, ANT.hexagonal(3))
		assert_equal(28, ANT.hexagonal(4))
		assert_equal(45, ANT.hexagonal(5))
	end

	def test_heptagonal
		assert_equal(1, ANT.heptagonal(1))
		assert_equal(7, ANT.heptagonal(2))
		assert_equal(18, ANT.heptagonal(3))
		assert_equal(34, ANT.heptagonal(4))
		assert_equal(55, ANT.heptagonal(5))
	end

	def test_octagonal
		assert_equal(1, ANT.octagonal(1))
		assert_equal(8, ANT.octagonal(2))
		assert_equal(21, ANT.octagonal(3))
		assert_equal(40, ANT.octagonal(4))
		assert_equal(65, ANT.octagonal(5))
	end
end
