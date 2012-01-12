module ANT
	module_function

	class Polynomial
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
		end
	end

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
