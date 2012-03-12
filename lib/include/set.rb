class Set
	include Enumerable

	def initialize(ary = [])
		@set = ary.uniq
	end

	def add(*items)
		items.each do |i|
			@set.push(i) unless @set.include?(i)
		end
		return self
	end

	def ==(other)
		return false unless self.size == other.size
		@set.each do |i|
			return false unless other.include?(i)
		end

		return true
	end

	def each(&block)
		@set.each(&block)
	end

	def size
		@set.size
	end

	def dup
		self.class.new(@set.dup)
	end

	def include?(a)
		@set.include?(a)
	end

	def inspect
		str = @set.inspect[1..-2]
		return "{" + str + "}"
	end

	def to_a
		return @set
	end
end

class SortableSet < Set
	def initialize(ary = [], &compare)
		@set = ary.uniq.sort(&compare)
		@compare = compare
	end

	def add(*items)
		items.each do |i|
			j = Bisect.bisect_left(@set, i, &@compare)
			@set.insert(j, i) unless @set[j] == i
		end
		return self
	end

	def dup
		self.class.new(@set.dup, &@compare)
	end
end
