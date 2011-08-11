require 'test/unit'
require 'abst'

class TC_Fundamental < Test::Unit::TestCase
	def test_gcd
		test_cases = [
			[3, 4, 1],
			[14, 21, 7],
		]

		test_cases.each do |a, b, g|
			assert_equal(g, gcd(a, b))
		end
	end

	def test_binary_gcd
		test_cases = [
			[3, 4, 1],
			[14, 21, 7],
			[1024, 32, 32],
		]

		test_cases.each do |a, b, g|
			assert_equal(g, binary_gcd(a, b))
		end
	end
end
