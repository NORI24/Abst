module Bisect
	module_function

	def bisect_left(list, item, lo = 0, hi = list.size, &compare)
		compare = :<=>.to_proc unless block_given?

		while lo < hi
			i = (lo + hi - 1) >> 1

			if 0 <= compare.call(list[i], item)
				hi = i
			else
				lo = i + 1
			end
		end

		return hi
	end

	def bisect_right(list, item, lo = 0, hi = list.size, &compare)
		compare = :<=>.to_proc unless block_given?

		while lo < hi
			i = (lo + hi - 1) >> 1

			if 0 < compare.call(list[i], item)
				hi = i
			else
				lo = i + 1
			end
		end

		return lo
	end

	def insert_left(list, item, lo = 0, hi = list.size, &block)
		i = bisect_left(list, item, lo, hi, &block)
		list.insert(i, item)
	end

	def insert_right(list, item, lo = 0, hi = list.size, &block)
		i = bisect_right(list, item, lo, hi, &block)
		list.insert(i, item)
	end

	# Locate the leftmost value exactly equal to item
	def index(list, item, &block)
		i = bisect_left(list, item, &block)
		return list[i] == item ? i : nil
	end

	# Find rightmost value less than item
	def find_lt(list, item, &block)
		i = bisect_left(list, item, &block)
		return list[i - 1] unless 0 == i
	end

	# Find rightmost value less than or equal to item
	def find_le(list, item, &block)
		i = bisect_right(list, item, &block)
		return list[i - 1] unless 0 == i
	end

	# Find leftmost value greater than item
	def find_gt(list, item, &block)
		i = bisect_right(list, item, &block)
		return list[i] unless list.size == i
	end

	# Find leftmost item greater than or equal to item
	def find_ge(list, item, &block)
		i = bisect_left(list, item, &block)
		return list[i] unless list.size == i
	end
end
