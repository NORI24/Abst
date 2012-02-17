module ANT
	def memoize(callback, cache = Hash.new)
		unless callback.instance_of?(Array)
			cls = [Class, Module].include?(self.class) ? self : self.class
			callback = [cls, callback]
		end
		cls, method = callback
		original = "__unmemoized_#{method}__"

		cls.class_eval do
			alias_method original, method
			private original
			define_method(method) {|*args| cache[args] ||= send(original, *args)}
		end
	end
end
