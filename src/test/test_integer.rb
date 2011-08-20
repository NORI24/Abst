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
end
