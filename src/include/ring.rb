module Abst
	module Ring
		def self.included(base)
			base.class_eval do
				include Abst::Group
			end
		end

		def /(other)
			return self.divmod(other)[0]
		end

		def %(other)
			return self.divmod(other)[1]
		end

		def **(e)
			return Abst.power(self, e)
		end
	end
end
