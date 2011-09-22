class Matrix < VectorCore
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

	def trace
		unless self.class.width == self.class.height
			raise MatrixSizeError, "this is not square matrix"
		end

		return self.map.with_index{|row, i| row[i]}.inject(&:+)
	end
end

def create_matrix(coef_class, height, width = nil)
	if height.kind_of?(Array)
		elems = height
		width = height[0].size
		height = height.size
	end

	matrix = Class.new(Matrix) do; end
	matrix.class_variable_set("@@coef_class", coef_class)
	matrix.class_variable_set("@@height", height)
	matrix.class_variable_set("@@width", width)
	matrix.class_variable_set("@@coef_vector", Vector(coef_class, width))
	matrix.class_eval %{
		def self.coef_class
			return @@coef_class
		end

		def self.height
			return @@height
		end

		def self.width
			return @@width
		end

		def self.coef_vector
			return @@coef_vector
		end
	}

	return matrix.new(elems) if elems
	return matrix
end
alias Matrix create_matrix

class MatrixSizeError < Exception; end
