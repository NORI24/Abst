class Vector < Array
	def +(other)
		raise VectorSizeError unless self.size == other.size
		return self.class.new(self.zip(other).map{|a, b| a + b})
	end

	def -(other)
		raise VectorSizeError unless self.size == other.size
		return self.class.new(self.zip(other).map{|a, b| a - b})
	end
end

def create_vector_space(coef_class, elems = nil)
	vector = Class.new(Vector) do; end
	vector.class_variable_set("@@coef_class", coef_class)
	vector.class_eval %{
		def self.coef_class
			return @@coef_class
		end
	}

	return vector.new(elems) if elems
	return vector
end
alias Vector create_vector_space

class VectorSizeError < Exception; end
