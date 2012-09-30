module Abst
	module_function

	class Matrix
		include Abst::Group

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

		def *(other)
			if self.class == other.class
				raise NotImplementedError
			end

			return self.class.new(@coef.map{|row| row.map{|i| i * other}})
		end

		# Param::  self must be n * (n + 1) matrix s.t. (MB)
		#          M is invertible n * n matrix
		#          B is a column vector
		# Return:: a column vector X s.t. MX == B
		def solve
			raise MatrixSizeError unless @height + 1 == @width

			inverse = []
			m = self.to_a
			n = @height

			n.times do |j|
				# Find non-zero entry
				row = nil
				j.upto(n - 1) do |i|
					unless m[i][j].zero?
						row = i
						break
					end
				end
				return nil unless row

				# Swap?
				if j < row
					m[row], m[j] = m[j], m[row]
				end

				# Eliminate
				inverse[j] = m[j][j].inverse
				(j + 1).upto(n - 1) do |i|
					c = m[i][j] * inverse[j]

					(j + 1).upto(n) do |j2|
						m[i][j2] -= m[j][j2] * c
					end
				end
			end

			# Solve triangular system
			x = []
			(n - 1).downto(0) do |i|
				temp = m[i][n]
				(i + 1).upto(n - 1) do |j|
					temp -= m[i][j] * x[j]
				end
				x[i] = temp * inverse[i]
			end

			return Abst::Vector(self.class.coef_class, x)
		end

		def to_a
			return @coef.map{|row| row.to_a}
		end

		def to_s
			return "[#{@coef.map(&:to_s).join(', ')}]"
		end

		def inspect
			return "#{self.class}\n#{self}"
		end
	end

	class SquareMatrix < Matrix
		include Abst::Ring

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
			@coef_vector = Abst::Vector(coef_class, width)
		end

		return matrix.new(elems) if elems
		return matrix
	end
	alias Matrix create_matrix
	module_function :Matrix

	class MatrixSizeError < Exception; end
end
