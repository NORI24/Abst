module ANT
	module Group
		def self.included(base)
			base.class_eval do
				[:+, :-].each do |sym|
					unless method_defined? sym
						define_method(sym) do |other|
							return add_sub(sym, other)
						end
					end
				end
			end
		end
	end

	def order(g)
		raise NotImplementedError
	end
end
