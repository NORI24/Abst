module Enumerable
	def sum
		rslt = nil
		self.each{|v| rslt ? rslt += yield(v) : rslt = yield(v)}
		return rslt
	end

	def prod
		rslt = nil
		self.each{|v| rslt ? rslt *= yield(v) : rslt = yield(v)}
		return rslt
	end
end
