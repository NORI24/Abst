module ANT
	module Ring
		include ANT::Group

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
