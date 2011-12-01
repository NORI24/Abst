class Array
	def each_coefficient(init = nil)
		init = Array.new(self.size, 0) unless init
		current = init

		loop do
			yield current

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

	def to_set
		return Set.new(self)
	end
end
