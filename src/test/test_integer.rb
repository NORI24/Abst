require 'test/unit'
require 'ant'

class TC_Fundamental < Test::Unit::TestCase
	def test_to_fs
		assert_equal('0', 0.to_fs)
		assert_equal('1', 1.to_fs)
		assert_equal('123 456 789', 123456789.to_fs)
		assert_equal('1 234 567 890', 1234567890.to_fs)
	end

	def test_bit_size
		assert_equal(0, 0.bit_size)
		assert_equal(1, 1.bit_size)
		assert_equal(2, 2.bit_size)
		assert_equal(2, 3.bit_size)
		assert_equal(3, 4.bit_size)
		assert_equal(3, 5.bit_size)
		assert_equal(10, 1023.bit_size)
		assert_equal(11, 1024.bit_size)
		assert_equal(11, 1025.bit_size)
	end

	def test_factorial
		assert_equal(1, 0.factorial)
		assert_equal(1, 1.factorial)
		assert_equal(2, 2.factorial)
		assert_equal(6, 3.factorial)
		assert_equal(24, 4.factorial)
		assert_equal(120, 5.factorial)
		assert_equal(720, 6.factorial)
	end

	def test_combination
		assert_equal(1, 1.combination(1))
		assert_equal(1, 1.combination(0))
		assert_equal(45, 10.combination(2))
		assert_equal(120, 10.combination(7))
	end

	def test_power_of?
		assert_equal(true, 2.power_of?(2))
		assert_equal(false, 3.power_of?(2))
		assert_equal(true, 36.power_of?(6))
		assert_equal(false, 100.power_of?(11))
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

	def test_squarefree?
		assert_equal(true, 1.squarefree?)
		assert_equal(true, 2.squarefree?)
		assert_equal(true, 3.squarefree?)
		assert_equal(false, 4.squarefree?)
		assert_equal(true, 5.squarefree?)
		assert_equal(true, 6.squarefree?)
		assert_equal(true, 7.squarefree?)
		assert_equal(false, 8.squarefree?)
		assert_equal(true, (7 * 13).squarefree?)
		assert_equal(false, (5 * 13 * 13).squarefree?)
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

	def test_heptagonal?
		assert_equal(1, 1.heptagonal?)
		assert_equal(false, 2.heptagonal?)
		assert_equal(false, 3.heptagonal?)
		assert_equal(false, 4.heptagonal?)
		assert_equal(false, 5.heptagonal?)
		assert_equal(false, 6.heptagonal?)
		assert_equal(2, 7.heptagonal?)
		assert_equal(false, 8.heptagonal?)
		assert_equal(3, 18.heptagonal?)
	end

	def test_octagonal?
		assert_equal(1, 1.octagonal?)
		assert_equal(false, 2.octagonal?)
		assert_equal(false, 3.octagonal?)
		assert_equal(false, 4.octagonal?)
		assert_equal(false, 5.octagonal?)
		assert_equal(false, 6.octagonal?)
		assert_equal(false, 7.octagonal?)
		assert_equal(2, 8.octagonal?)
		assert_equal(false, 9.octagonal?)
		assert_equal(3, 21.octagonal?)
	end
end
