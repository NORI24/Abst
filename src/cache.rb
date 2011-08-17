class Cache
	@@prefix = 'abst_cache_'

	def self.save(cache_name, data)
		path = get_path(cache_name)

		Dir::mkdir(CACHE_DIR) unless FileTest.exist?(CACHE_DIR)
		open(path, "w") {|io| Marshal.dump(data, io)}
	end

	def self.load(cache_name)
		path = get_path(cache_name)

		if FileTest.exist?(path)
			open(path) {|io| return Marshal.load(io)}
		end

		unless block_given?
			raise RuntimeError, "There is no cache data '#{cache_name}'"
		end

		data = yield
		save(cache_name, data)

		return data
	end

	def self.delete(cache_name)
		path = get_path(cache_name)

		File.delete(path) if FileTest.exist?(path)
	end

	def self.delete_all
		raise NotImplementedError
	end

	def self.exist?(cache_name)
		return FileTest.exist?(get_path(cache_name))
	end

	def self.get_path(cache_name)
		raise ArgumentError, "Invalid cache_name. (a-z 0-9 and _ are available)" unless /[a-z0-9_]+/ =~ cache_name

		return CACHE_DIR + @@prefix + cache_name
	end
end