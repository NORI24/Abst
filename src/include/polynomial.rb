module ANT
	module_function

	class Polynomial
		include ANT::Ring

		class << self
			attr_reader :coef_class

			def zero
				return self.new([coef_class.zero])
			end

			def one
				return self.new([coef_class.one])
			end
		end

		attr_accessor :coef

		def initialize(coef)
			@coef = VectorCore.new(coef)
			cutdown
		end

		def add_sub(other, op)
			a = @coef
			b = other.kind_of?(self.class.coef_class) ? [other] : other.coef
			a, b = b, a if a.size < b.size
			coef = a.dup
			b.size.times {|i| coef[i] = coef[i].__send__(op, b[i])}
			return self.class.new(coef)
		end

		def *(other)
			raise NotImplementedError
		end

		def divmod(other)
			raise NotImplementedError
		end

		def ==(other)
			raise NotImplementedError
		end

		def degree
			raise NotImplementedError
		end

		# leading coefficient
		def lc
			raise NotImplementedError
		end

		def execute(x)
			raise NotImplementedError
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
	end

	# Param::  immutable class coef_class
	def create_polynomial(coef_class, coef = nil)
		poly = Class.new(Polynomial) do
			@coef_class = coef_class
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
