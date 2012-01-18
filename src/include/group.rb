module ANT
	module Group
		def +(other)
			return add_sub(other, :+)
		end

		def -(other)
			return add_sub(other, :-)
		end
	end
end
