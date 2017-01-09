require 'minitest/autorun'
require 'abst'

class TC_PrimeMPQS < MiniTest::Test
	def test_primes_list
		test = lambda do |n|
			factor = Abst.mpqs(n)
			assert(1 < factor && factor < n)
			assert_equal(0, n % factor)
		end

		test.call(23916353875143281737)
		test.call(56428599095241190007)
		test.call(24559500716705748943)
		test.call(43381522922949440477)
		test.call(19238749214625480671)
		test.call(25498058878476331907)
		test.call(9530738504299322287)
		test.call(18193861945465859131)
		test.call(79670656009259581439)
		test.call(19256936255213267029)
	end
end
