require 'minitest/unit'
require 'minitest/autorun'
require 'ant'

class TC_Set < MiniTest::Unit::TestCase
	def test_add
		assert_equal(Set.new([1, 2, 3]), Set.new([1, 3]).add(2))
		assert_equal(Set.new([2, 1, 2, 3]), Set.new([1, 2, 3]).add(2))
		assert_equal(Set.new([3, 1, 2, 3, 5]), Set.new([5, 2, 3, 1]).add(2))
	end

	def test_dup
		s1 = Set.new([1, 2, 3])
		s2 = s1.dup
		s2.add(4)

		assert_equal(Set.new([1, 2, 3]), s1)
	end
end

class TC_SortableSet < MiniTest::Unit::TestCase
	def test_add
		assert_equal(SortableSet.new([1, 2, 3]), SortableSet.new([1, 3]).add(2))
		assert_equal(SortableSet.new([2, 1, 2, 3]), SortableSet.new([1, 2, 3]).add(2))
		assert_equal(SortableSet.new([3, 1, 2, 3, 5]), SortableSet.new([5, 2, 3, 1]).add(2))
	end

	def test_dup
		s1 = SortableSet.new([1, 2, 3]){|a, b| b <=> a}
		s2 = s1.dup
		assert_equal(s1.to_a, s2.to_a)

		s2.add(4)
		assert_equal(Set.new([1, 2, 3]), s1)
	end
end
