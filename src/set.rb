class Set
	def initialize(ary = [])
		@set = ary.uniq
	end

	def add(a)
		@set.push(a) unless @set.include?(a)
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

	def add(a)
		i = Bisect.bisect_left(@set, a, &@compare)
		@set.insert(i, a) unless @set[i] == a
		return self
	end

	def dup
		self.class.new(@set.dup, &@compare)
	end
end
