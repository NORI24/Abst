require 'minitest/unit'
require 'minitest/autorun'
require 'abst'

class TC_Symbol < MiniTest::Unit::TestCase
	def test_eval
		assert_equal(3, :x.eval(x: 3))
	end

	def test_operation
		assert_equal(4, (:x + 1).eval(x: 3))
		assert_equal(2, (:x - 1).eval(x: 3))
		assert_equal(6, (:x * 2).eval(x: 3))
		assert_equal(2, (:x / 2).eval(x: 4))
		assert_equal(9, (:x ** 2).eval(x: 3))
	end

	def test_coerce
		assert_equal 2, (2 * :x).eval(1)
	end
end

class TC_Expression < MiniTest::Unit::TestCase
	def test_initialize
		t = Expression.new(:x, :+, 1)
		assert_equal(:x, t.instance_eval{@receiver})
		assert_equal(:+, t.instance_eval{@method})
		assert_equal([1], t.instance_eval{@args})

		t = Expression.new(2)
		assert_equal(2, t.instance_eval{@receiver})
		assert_equal(nil, t.instance_eval{@method})
		assert_equal([], t.instance_eval{@args})

		t = Expression.new(2, :-@)
		assert_equal(2, t.instance_eval{@receiver})
		assert_equal(:-@, t.instance_eval{@method})
		assert_equal([], t.instance_eval{@args})
	end

	def test_eval
		assert_equal(5, (:x + 2).eval(x: 3))
		assert_equal(4, Expression.new(4).eval)
		assert_equal(3, (1 + :y).eval(y: 2))
	end

	def test_to_s
		assert_equal 'x + 2', (:x + 2).to_s
		assert_equal 'x ** 2 + 2', (:x ** 2 + 2).to_s
		assert_equal '2 * x', (2 * :x).to_s
	end

	def test_coerce
		assert_equal 18, (2 * :x ** 2).eval(3)
	end
end
