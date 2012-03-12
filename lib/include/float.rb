class Float
	def self.one
		return 1.0
	end

	def self.zero
		return 0.0
	end

	def inverse
		return 1.0 / self
	end

	# Return:: formatted string
	def to_fs
		return self.to_s.gsub(/(?<=\d)(?=(\d\d\d)+\.)/, ' ')
	end
end

