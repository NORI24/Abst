require 'minitest/autorun'
require 'abst'

class TC_Float < MiniTest::Test
	def test_to_fs
		assert_equal('0.0', 0.to_f.to_fs)
		assert_equal('0.123456789', (0.123456789).to_fs)
		assert_equal('1.0', 1.to_f.to_fs)
		assert_equal('123 456 789.0', 123456789.to_f.to_fs)
		assert_equal('1 234 567 890.0', 1234567890.to_f.to_fs)
	end
end
