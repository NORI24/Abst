module ANT
	module_function

	class VectorCore < Array
		class << self
			attr_reader :coef_class, :size
		end

		def +(other)
			raise VectorSizeError unless self.size == other.size
			return self.class.new(self.zip(other).map{|a, b| a + b})
		end

		def -(other)
			raise VectorSizeError unless self.size == other.size
			return self.class.new(self.zip(other).map{|a, b| a - b})
		end

		def squared_length
			return self.map{|i| i ** 2}.inject(&:+)
		end
	end

	class Vector < VectorCore
		def initialize(elems)
			raise VectorSizeError unless elems.size == self.class.size
			super
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
