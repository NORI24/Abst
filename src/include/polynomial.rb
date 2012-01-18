module ANT
	module_function

	class Polynomial
		include ANT::Ring

		class << self
			attr_reader :coef_class, :zero, :one
		end

		attr_reader :coef
		protected :coef

		def initialize(coef)
			@coef = coef.to_a
			cutdown
		end

		def add_sub(op, other)
			a = @coef
			b = other.kind_of?(self.class.coef_class) ? [other] : other.coef
			a, b = b, a if a.size < b.size
			rslt_coef = a.dup
			b.size.times {|i| rslt_coef[i] = rslt_coef[i].__send__(op, b[i])}
			return self.class.new(rslt_coef)
		end

		def *(other)
			other = other.kind_of?(self.class.coef_class) ? [other] : other.coef
			rslt_coef = Array.new(@coef.size + other.size - 1, self.class.coef_class.zero)

			@coef.size.times do |j|
				other.size.times do |i|
					rslt_coef[i + j] += @coef[j] * other[i]
				end
			end

			return self.class.new(rslt_coef)
		end

		def divmod(other)
			other = other.kind_of?(self.class.coef_class) ? [other] : other.coef
			q = [self.class.coef_class.zero]
			r = @coef.dup

			lc_other = other.last
			(@coef.size - other.size).downto(0) do |i|
				tq, tr = r.pop.divmod(lc_other)
				raise NotImplementedError unless self.class.coef_class.zero == tr
				q[i] = tq
				next if self.class.coef_class.zero == tq

				(other.size - 1).times do |j|
					r[i + j] -= tq * other[j]
				end
			end

			r[0] = self.class.coef_class.zero if r.empty?
			return self.class.new(q), self.class.new(r)
		end

		def ==(other)
			other = other.kind_of?(self.class.coef_class) ? [other] : other.coef
			return @coef == other
		end

		def degree
			return -INFINITY if 1 == @coef.size and @coef[0] == self.class.coef_class.zero
			return @coef.size - 1
		end

		# leading coefficient
		def lc
			return @coef.last
		end

		def eval(x)
			rslt = @coef.last
			(@coef.size - 2).downto(0) do |i|
				rslt = rslt * x + @coef[i]
			end

			return rslt
		end

		def normalize!
			raise NotImplementedError
		end

		def normalize
			return self.dup.normalize!
		end

		# delete last zero-entries
		def cutdown
			zero = self.class.coef_class.zero

			return if zero != @coef.last

			# find last non-zero entry
			idx = 0
			(@coef.size - 2).downto(1) do |i|
				if @coef[i] != zero
					idx = i
					break
				end
			end

			@coef[idx + 1, @coef.size] = []
		end

		def to_a
			return @coef.dup
		end
	end

	# Param::  immutable class coef_class
	def create_polynomial(coef_class, coef = nil)
		poly = Class.new(Polynomial) do
			@coef_class = coef_class
			@zero = self.new([coef_class.zero]).freeze
			@one = self.new([coef_class.one]).freeze
		end

		return poly.new(coef) if coef
		return poly
	end

	alias Polynomial create_polynomial
	module_function :Polynomial

	# Param::
	# Return::
	def root_mod_p
		raise NotImplementedError
	end
end
