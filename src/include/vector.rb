module ANT
	module_function

	class Vector
		class << self
			attr_reader :coef_class, :size
		end

		attr_reader :coef
		protected :coef

		def initialize(coef)
			raise VectorSizeError unless coef.size == self.class.size
			@coef = coef.to_a
		end

		def +(other)
			raise VectorSizeError unless self.size == other.size
			return self.class.new(self.coef.zip(other.coef).map{|a, b| a + b})
		end

		def -(other)
			raise VectorSizeError unless self.size == other.size
			return self.class.new(self.coef.zip(other.coef).map{|a, b| a - b})
		end

		def size
			return self.class.size
		end

		def each
			return Enumerator.new(self) unless block_given?

			@coef.each do |i|
				yield i
			end
		end

		def squared_length
			return self.coef.map{|i| i ** 2}.inject(&:+)
		end

		def to_a
			return @coef.dup
		end

		def [](index)
			return @coef[index]
		end

		def inspect
			return @coef.inspect
		end
	end

	def create_vector_space(coef_class, size)
		if size.kind_of?(Array)
			elems = size
			size = size.size
		end

		vector = Class.new(Vector) do
			@coef_class = coef_class
			@size = size
		end

		return vector.new(elems) if elems
		return vector
	end
	alias Vector create_vector_space
	module_function :Vector

	class VectorSizeError < Exception; end
end
