module Abst
	# http://en.wikipedia.org/wiki/Hungarian_algorithm
	class HungarianMethod
		def initialize(matrix)
			@matrix = matrix.map {|row| row.dup.freeze}.freeze
			@height = @matrix.size
			@width = @matrix[0].size
			@size = [@height, @width].max

			# Cache
			@min_coordinates = nil
			@max_coordinates = nil
			@assign_cache = {}
		end

		# Return Array coordinates for minimum
		def min_coordinates
			return @min_coordinates if @min_coordinates

			# Initialize
			# Convert to square matrix by adding zero filled rows or columns.
			if @width < @height
				m = @matrix.map do |row|
					row.dup.fill(0, @width, @height - @width)
				end
			else
				m = @matrix.map {|row| row.dup}
				(@width - @height).times do
					m << Array.new(@width, 0)
				end
			end

			# Step 1
			m.each do |row|
				min = row.min
				next row.dup if min.zero?
				@size.times {|i| row[i] -= min}
			end

			# Step 2
			@size.times do |j|
				min = m.map{|row| row[j]}.min
				next if min.zero?
				m.each{|row| row[j] -= min}
			end

			loop do
				# Step 3
				assign, cover = assign_or_cover(m)
				if assign
					return @min_coordinates = assign.sort.select do |i, j|
						i < @height and j < @width
					end
				end

				# Step 4
				rows_cover, cols_cover = cover
				# complement set
				rows_cover_cmp = (0...@size).to_a - rows_cover
				cols_cover_cmp = (0...@size).to_a - cols_cover

				min = Float::INFINITY
				rows_cover_cmp.each do |i|
					cols_cover_cmp.each do |j|
						v = m[i][j]
						min = v if v < min
					end
				end

				rows_cover_cmp.each do |i|
					cols_cover_cmp.each do |j|
						m[i][j] -= min
					end
				end
				rows_cover.each do |i|
					cols_cover.each do |j|
						m[i][j] += min
					end
				end
			end
		end

		def min
			return min_coordinates.map {|i, j| @matrix[i][j]}.inject(&:+)
		end

		# Return Array coordinates for maximum
		def max_coordinates
			unless @max_coordinates
				max = @matrix.map(&:max).max
				@max_coordinates = self.class.new(@matrix.map{|row| row.map{|i| max - i}}).min_coordinates
			end

			return @max_coordinates
		end

		def max
			return max_coordinates.map {|i, j| @matrix[i][j]}.inject(&:+)
		end

		# Return: Array | false If it is possible to assign then return Array of j-coordinates for i=1, 2, ...
		def assign_or_cover(matrix)
			rows = @size.times.to_a
			cols = @size.times.to_a
			coordinates = []
			rows_cover = []
			cols_cover = []

			# Temporary assignment
			# Also find blocks possible to assign.
			classify = Hash.new{|hash, key| hash[key] = []}
			loop do
				assigned = false

				# Find zeros in each row
				classify.clear
				rows.dup.each do |i|
					row = matrix[i]
					zero_cols = cols.map {|j| row[j].zero?? j : nil}.compact

					case zero_cols.size
					when 0
						rows_cover += rows.select do |i2|
							cols.map {|j| matrix[i2][j]}.include?(0)
						end
						return nil, [rows_cover, cols_cover]
					when 1
						j = zero_cols.first
						rows.delete(i)
						cols.delete(j)
						coordinates << [i, j]
						cols_cover << j
						assigned = true
					else
						classify[zero_cols] << i
						if zero_cols.size <= classify[zero_cols].size
							zero_cols.zip(classify[zero_cols]) do |jj, ii|
								rows.delete(ii)
								cols.delete(jj)
								coordinates << [ii, jj]
								cols_cover << jj
							end
							assigned = true
						end
					end
				end

				# Find zeros in each col
				classify.clear
				cols.dup.each do |j|
					zero_rows = rows.map {|i| matrix[i][j].zero?? i : nil}.compact

					case zero_rows.size
					when 0
						cols_cover += cols.select do |j2|
							rows.map {|i| matrix[i][j2]}.include?(0)
						end
						return nil, [rows_cover, cols_cover]
					when 1
						i = zero_rows.first
						rows.delete(i)
						cols.delete(j)
						coordinates << [i, j]
						rows_cover << i
						assigned = true
					else
						classify[zero_rows] << j
						if zero_rows.size <= classify[zero_rows].size
							zero_rows.zip(classify[zero_rows]) do |ii, jj|
								rows.delete(ii)
								cols.delete(jj)
								coordinates << [ii, jj]
								rows_cover << ii
							end
							assigned = true
						end
					end
				end

				break unless assigned
			end

			return coordinates, nil if rows.empty?

			# Try to completely assign
			sub_coordinates = assign(matrix, rows, cols)
			@assign_cache.clear
			return coordinates + sub_coordinates, nil if sub_coordinates

			# Cover zeros by rows and cols
			r_cover, c_cover = cover(matrix, rows, cols)
			return nil, [rows_cover + r_cover, cols_cover + c_cover]
		end

		# Try to assign
		# Param: Array matrix  Actually this method treat the submatrix represented by rows and cols.
		# Param: Array rows  Array of Integers
		# Param: Array cols  Array of Integers
		# Return Array | false
		def assign(matrix, rows, cols)
			unless (_ = @assign_cache[cols]).nil?
				return _
			end

			return [] if rows.empty?

			i = rows.first
			row = matrix[i]
			cols.each do |j|
				next unless row[j].zero?

				c = assign(matrix, rows[1..-1], cols - [j])
				return @assign_cache[cols] = c.unshift([i, j]) if c
			end

			return @assign_cache[cols] = false
		end

		# Try to cover zeros by lines less than line_num.
		# Param: Array matrix  Actually this method treat the submatrix represented by rows and cols.
		# Param: Array rows  Array of Integers
		# Param: Array cols  Array of Integers
		# Param: Integer line_num
		# Return: Array | false  if all zeros are covered then return array how to cover [[rows], [cols]] otherwise false
		def cover(matrix, rows, cols, line_num = rows.size - 1)
			if line_num <= 0
				return false if line_num < 0
				rows.each do |i|
					row = matrix[i]
					cols.each do |j|
						return false if row[j].zero?
					end
				end
				return [], []
			end

			# Count the number of 0's per row and column
			zeros_per_row = Array.new(@size, 0)
			zeros_per_col = Array.new(@size, 0)
			rows.each do |i|
				row = matrix[i]
				cols.each do |j|
					next unless row[j].zero?
					zeros_per_row[i] += 1
					zeros_per_col[j] += 1
				end
			end

			row_max = zeros_per_row.max
			col_max = zeros_per_col.max
			if row_max < col_max
				return [], [] if col_max.zero?
				j = zeros_per_col.index(col_max)
				rows_cover, cols_cover = cover(matrix, rows, cols - [j], line_num - 1)
				return rows_cover, cols_cover.unshift(j) if rows_cover

				zeros = rows.map {|i| matrix[i][j].zero?? i : nil}.compact
				rows_cover, cols_cover = cover(matrix, rows - zeros, cols - [j], line_num - zeros.size)
				return rows_cover + zeros, cols_cover if rows_cover
			else
				return [], [] if row_max.zero?
				i = zeros_per_row.index(row_max)
				rows_cover, cols_cover = cover(matrix, rows - [i], cols, line_num - 1)
				return rows_cover.unshift(i), cols_cover if rows_cover

				row = matrix[i]
				zeros = cols.map {|jj| row[jj].zero?? jj : nil}.compact
				rows_cover, cols_cover = cover(matrix, rows - [i], cols - zeros, line_num - zeros.size)
				return rows_cover, cols_cover + zeros if rows_cover
			end

			return false
		end
	end
end
