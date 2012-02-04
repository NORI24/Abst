class Array
	def each_coefficient(init = nil)
		return Enumerator.new(self, :each_coefficient, init) unless block_given?

		init = Array.new(self.size, 0) unless init
		current = init.dup

		loop do
			yield current.dup

			# next coef
			self.size.times do |i|
				if self[i] == current[i]
					return if i == self.size - 1
					current[i] = 0
				else
					current[i] += 1
					break
				end
			end
		end
	end

	def to_set(sortable = true, &compare)
		return SortableSet.new(self, &compare) if sortable
		return Set.new(self)
	end

	# to_vector
	def to_v(coef_class = nil)
		vector = Vector(coef_class || self[0].class, self.size)
		return vector.new(self)
	end

	# to_matrix
	def to_m(coef_class = nil)
		matrix = Matrix(coef_class || self[0][0].class, self.size, self[0].size)
		return matrix.new(self)
	end
end
