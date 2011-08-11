require 'test/unit'
require 'abst'

class TC_Prime < Test::Unit::TestCase
	def test_trial_division
		test_cases = [
			[1, nil],
			[2, nil],
			[3, nil],
			[4, 2],
			[5, nil],
			[6, 2],
			[11, nil],
			[169, 13],
		]

		test_cases.each do |n, expect|
			rslt = trial_division(n)

			assert_equal(expect, rslt)
		end
	end

	def test_prime?
		test_cases = [
			[1, false],
			[2, true],
			[3, true],
			[4, false],
			[5, true],
			[6, false],
			[7, true],
			[8, false],
			[9, false],
			[10, false],
			[11, true],
			[12, false],
			[13, true],
		]

		test_cases.each do |n, expect|
			assert_equal(expect, prime?(n))
		end
	end
end
