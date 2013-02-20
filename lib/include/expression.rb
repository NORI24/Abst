class Expression
	def initialize(receiver, method = nil, *args)
		@receiver = receiver
		@method = method
		@args = args
	end

	def eval(assignment = {})
		receiver = @receiver.class.method_defined?(:eval) ? @receiver.eval(assignment) : @receiver
		return receiver unless @method
		receiver.__send__(@method, *@args.map{|i| i.class.method_defined?(:eval) ? i.eval(assignment) : i})
	end

	def method_missing(name, *args)
		self.class.new(self, name.to_sym, *args)
	end
end

class Symbol
	def eval(assignment)
		assignment[self] || self
	end

	def +(other)
		Expression.new(self, :+, other)
	end

	def coerce(other)
		[Expression.new(other), self]
	end
end
