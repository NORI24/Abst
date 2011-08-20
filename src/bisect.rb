module Bisect
	module_function

	def bisect_left(list, item, lo = 0, hi = list.size)
		while lo < hi
			i = (lo + hi - 1) >> 1

			if item <= list[i]
				hi = i
			else
				lo = i + 1
			end
		end

		return hi
	end

	def bisect_right(list, item, lo = 0, hi = list.size)
		while lo < hi
			i = (lo + hi - 1) >> 1

			if item < list[i]
				hi = i
			else
				lo = i + 1
			end
		end

		return lo
	end

	def insort_left(list, item, lo = 0, hi = list.size)
		i = bisect_left(list, item, lo, hi)
		list.insert(i, item)
	end

	def insort_right(list, item, lo = 0, hi = list.size)
		i = bisect_right(list, item, lo, hi)
		list.insert(i, item)
	end

	# Locate the leftmost value exactly equal to item
	def index(list, item)
		i = bisect_left(list, item)
		return i if list[i] == item
	end

	# Find rightmost value less than item
	def find_lt(list, item)
		i = bisect_left(list, item)
		return list[i - 1] unless 0 == i
	end

	# Find rightmost value less than or equal to item
	def find_le(list, item)
		i = bisect_right(list, item)
		return list[i - 1] unless 0 == i
	end

	# Find leftmost value greater than item
	def find_gt(list, item)
		i = bisect_right(list, item)
		return list[i] unless list.size == i
	end

	# Find leftmost item greater than or equal to item
	def find_ge(list, item)
		i = bisect_left(list, item)
		return list[i] unless list.size == i
	end
end