module Abst
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

	def element_order(g, group_order)
		one = g.class.one
		order = group_order
		factor = factorize(group_order)

		factor.each do |f, e|
			order /= f ** e

			t = g ** order
			until one == t
				t **= f
				order *= f
			end
		end

		return order
	end
end
