module ANT
	module Ring
		def +(other)
			return add_sub(other, :+)
		end

		def -(other)
			return add_sub(other, :-)
		end

		def /(other)
			return self.divmod(other)[0]
		end

		def %(other)
			return self.divmod(other)[1]
		end

		def **(e)
			return power(self, e)
		end
	end
end
