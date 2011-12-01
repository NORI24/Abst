class Set
	def initialize(ary)
		@set = ary
	end

	def add(a)
		i = Bisect.bisect_left(@set, a)
		return self if @set[i] == a

		@set.insert(i, a)
		return self
	end

	def ==(other)
		return @set == other.to_a
	end

	def each(&block)
		@set.each(&block)
	end

	def size
		@set.size
	end

	def inspect
		str = @set.inspect[1..-2]
		return "{" + str + "}"
	end

	def to_a
		return @set
	end
end
