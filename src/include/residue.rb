module Abst
	def residue_class(ideal)
		if prime?(ideal.n)
			return residue_class_field(ideal)
		else
			return residue_class_ring(ideal)
		end
	end

	def residue_class_ring(ideal)
		residue_class = Class.new(IntegerResidueRing) do
			@mod = ideal.n
		end

		return residue_class
	end

	def residue_class_field(maximal_ideal)
		residue_class = Class.new(IntegerResidueField) do
			@mod = maximal_ideal.n
		end

		return residue_class
	end
end
