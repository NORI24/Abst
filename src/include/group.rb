module ANT
	module Group
		def self.included(base)
			base.class_eval do
				[:+, :-].each do |sym|
					unless method_defined? sym
						define_method(sym) do |other|
							return add_sub(other, sym)
						end
					end
				end
			end
		end
	end
end
