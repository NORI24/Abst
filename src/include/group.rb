module ANT
	module Group
		def self.included(base)
			base.class_eval do
				unless method_defined? :+
					def +(other)
						return add_sub(other, :+)
					end
				end

				unless method_defined? :-
					def -(other)
						return add_sub(other, :-)
					end
				end
			end
		end
	end
end
