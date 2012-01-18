module ANT
	module_function

	class Matrix < VectorCore
		class << self
			attr_reader :coef_class, :height, :width, :coef_vector
		end

		def initialize(m)
			raise MatrixSizeError unless m.size == self.class.height

			# vectorization each row
			super(m.map{|row| self.class.coef_vector.new(row)})
		rescue VectorSizeError
			raise MatrixSizeError
		end

		def +(other)
			return super
		rescue VectorSizeError
			raise MatrixSizeError
		end

		def -(other)
			return super
		rescue VectorSizeError
			raise MatrixSizeError
		end
	end

	class SquareMatrix < Matrix
		include ANT::Ring

		def trace
			return self.map.with_index{|row, i| row[i]}.inject(&:+)
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
			@coef_vector = ANT.Vector(coef_class, width)
		end

		return matrix.new(elems) if elems
		return matrix
	end
	alias Matrix create_matrix
	module_function :Matrix

	class MatrixSizeError < Exception; end
end
