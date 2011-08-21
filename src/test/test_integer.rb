require 'test/unit'
require 'abst'

class TC_Fundamental < Test::Unit::TestCase
	def test_factorial
		assert_equal(1, 0.factorial)
		assert_equal(1, 1.factorial)
		assert_equal(2, 2.factorial)
		assert_equal(6, 3.factorial)
		assert_equal(24, 4.factorial)
		assert_equal(120, 5.factorial)
		assert_equal(720, 6.factorial)
	end

	def test_square?
		assert_equal(1, 1.square?)
		assert_equal(false, 2.square?)
		assert_equal(false, 3.square?)
		assert_equal(2, 4.square?)
		assert_equal(false, 5.square?)
		assert_equal(13, 169.square?)
		assert_equal(false, 42342341.square?)

		10.times do
			n = rand(10 ** 10) + 1
			square = n ** 2
			assert_equal(n, square.square?)
			assert_equal(false, (square + 1).square?)
		end
	end

	def test_triangle?
		assert_equal(1, 1.triangle?)
		assert_equal(false, 2.triangle?)
		assert_equal(2, 3.triangle?)
		assert_equal(false, 4.triangle?)
		assert_equal(false, 5.triangle?)
		assert_equal(3, 6.triangle?)
		assert_equal(false, 7.triangle?)
	end

	def test_pentagonal?
		assert_equal(1, 1.pentagonal?)
		assert_equal(false, 2.pentagonal?)
		assert_equal(false, 3.pentagonal?)
		assert_equal(false, 4.pentagonal?)
		assert_equal(2, 5.pentagonal?)
		assert_equal(false, 6.pentagonal?)
	end

	def test_hexagonal?
		assert_equal(1, 1.hexagonal?)
		assert_equal(false, 2.hexagonal?)
		assert_equal(false, 3.hexagonal?)
		assert_equal(false, 4.hexagonal?)
		assert_equal(false, 5.hexagonal?)
		assert_equal(2, 6.hexagonal?)
		assert_equal(false, 7.hexagonal?)
	end
end
