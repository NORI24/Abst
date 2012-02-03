module ANT
	module_function

	class Matrix
		include ANT::Group

		class << self
			attr_reader :coef_class, :height, :width, :coef_vector

			def to_s
				return "#{height} * #{width} #{self.coef_class} Matrix"
			end

			def inspect
				return to_s
			end
		end

		attr_reader :coef, :height, :width
		protected :coef

		def initialize(m)
			raise MatrixSizeError unless self.class.height == m.size
			@coef = m.map{|row| self.class.coef_vector.new(row)}
			@height = self.class.height
			@width = self.class.width
		rescue VectorSizeError
			raise MatrixSizeError
		end

		def each
			return Enumerator.new(self) unless block_given?

			@coef.each do |row|
				row.each do |i|
					yield i
				end
			end
		end

		def add_sub(op, other)
			return self.class.new(@coef.zip(other.coef).map{|a, b| a.__send__(op, b)})
		end

		def solve
		end

		def to_a
			return @coef.map{|row| row.to_a}
		end

		def to_s
			return @coef.inspect
		end

		def inspect
			return "#{self.class}\n#{self}"
		end
	end

	class SquareMatrix < Matrix
		include ANT::Ring

		def trace
			return @coef.map.with_index{|row, i| row[i]}.inject(&:+)
		end
	end

	def create_matrix(coef_class, height, width = nil)
		if height.kind_of?(Array)
			elems = height
			width = height[0].size
			height = height.size
		end

		super_class = height == width ? SquareMatrix : Matrix
		matrix = Class.new(super_class) do
			@coef_class = coef_class
			@height = height
			@width = width
			@coef_vector = ANT::Vector(coef_class, width)
		end

		return matrix.new(elems) if elems
		return matrix
	end
	alias Matrix create_matrix
	module_function :Matrix

	class MatrixSizeError < Exception; end
end
