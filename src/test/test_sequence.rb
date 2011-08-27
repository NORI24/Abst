require 'test/unit'
require 'abst'

class TC_Fundamental < Test::Unit::TestCase
	def test_fibonacci
		assert_equal(1, fibonacci(1))
		assert_equal(1, fibonacci(2))
		assert_equal(2, fibonacci(3))
		assert_equal(3, fibonacci(4))
		assert_equal(5, fibonacci(5))
		assert_equal(12586269025, fibonacci(50))
		assert_equal(354224848179261915075, fibonacci(100))
	end

	def test_triangle
		assert_equal(1, triangle(1))
		assert_equal(3, triangle(2))
		assert_equal(6, triangle(3))
		assert_equal(10, triangle(4))
		assert_equal(15, triangle(5))
	end

	def test_pentagonal
		assert_equal(1, pentagonal(1))
		assert_equal(5, pentagonal(2))
		assert_equal(12, pentagonal(3))
		assert_equal(22, pentagonal(4))
		assert_equal(35, pentagonal(5))
	end

	def test_hexagonal
		assert_equal(1, hexagonal(1))
		assert_equal(6, hexagonal(2))
		assert_equal(15, hexagonal(3))
		assert_equal(28, hexagonal(4))
		assert_equal(45, hexagonal(5))
	end

	def test_heptagonal
		assert_equal(1, heptagonal(1))
		assert_equal(7, heptagonal(2))
		assert_equal(18, heptagonal(3))
		assert_equal(34, heptagonal(4))
		assert_equal(55, heptagonal(5))
	end

	def test_octagonal
		assert_equal(1, octagonal(1))
		assert_equal(8, octagonal(2))
		assert_equal(21, octagonal(3))
		assert_equal(40, octagonal(4))
		assert_equal(65, octagonal(5))
	end
end
