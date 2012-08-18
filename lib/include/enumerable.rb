module Enumerable
	def sum
		return self.inject(&:+) unless block_given?
		rslt = nil
		self.each{|v| rslt ? rslt += yield(v) : rslt = yield(v)}
		return rslt
	end

	def prod
		return self.inject(&:*) unless block_given?
		rslt = nil
		self.each{|v| rslt ? rslt *= yield(v) : rslt = yield(v)}
		return rslt
	end
end
