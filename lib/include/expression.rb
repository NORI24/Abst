class Expression
	def initialize(receiver, method = nil, *args)
		@receiver = receiver
		@method = method
		@args = args
	end

	def eval(assignment = {})
		receiver = @receiver.respond_to?(:eval) ? @receiver.eval(assignment) : @receiver
		return receiver unless @method
		receiver.__send__(@method, *@args.map{|i| i.respond_to?(:eval) ? i.eval(assignment) : i})
	end

	def method_missing(name, *args)
		self.class.new(self, name.to_sym, *args)
	end

	def to_s
		return @receiver.to_s unless @method
		@receiver.to_s + ' ' + @method.to_s + ' ' + @args.first.to_s
	end

	def coerce(other)
		[Expression.new(other), self]
	end
end

class Symbol
	def eval(assignment)
		return assignment.instance_of?(Hash) ? assignment[self] || self : assignment
	end

	[:+, :-, :*, :/, :**].each do |op|
		define_method op do |other|
			Expression.new(self, op, other)
		end
	end

	def coerce(other)
		[Expression.new(other), self]
	end
end
