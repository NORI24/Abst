class Set
	def initialize(ary)
		@set = ary
	end

	def add(a)
		return self if @set.include?(a)
		@set.push(a)
		@set.sort!

		return self
	end

	def ==(other)
		return @set == other.to_a
	end

	def to_a
		return @set
	end

	def inspect
		str = @set.inspect[1..-2]
		return "{" + str + "}"
	end
end
