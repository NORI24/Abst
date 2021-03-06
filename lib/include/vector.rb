require 'forwardable'

module Abst
	module_function

	class Vector
		class << self
			attr_reader :coef_class, :size

			def to_s
				return "#{size} length #{self.coef_class} Vector"
			end

			def inspect
				return to_s
			end
		end

		extend Forwardable

		attr_reader :coef
		protected :coef
		def_delegators :@coef, :each, :map, :to_s, :[]
		def_delegator :@coef, :dup, :to_a

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

		def ==(other)
			return @coef == other.to_a
		end

		def size
			return self.class.size
		end

		def squared_length
			return self.coef.map{|i| i ** 2}.inject(&:+)
		end

		def inspect
			return "#{self.class}\n#{self}"
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
