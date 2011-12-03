class Cache
	@@prefix = 'abst_cache_'

	def self.[]=(cache_id, data)
		path = get_path(cache_id)

		Dir::mkdir(CACHE_DIR) unless FileTest.exist?(CACHE_DIR)
		open(path, "w") {|io| Marshal.dump(data, io)}
	end

	def self.[](cache_id)
		path = get_path(cache_id)

		if FileTest.exist?(path)
			open(path) {|io| return Marshal.load(io)}
		end

		unless block_given?
			raise RuntimeError, "There is no cache data '#{cache_id}'"
		end

		data = yield
		save(cache_id, data)

		return data
	end

	def self.delete(cache_id)
		path = get_path(cache_id)

		File.delete(path) if FileTest.exist?(path)
	end

	def self.delete_all
		raise NotImplementedError
	end

	def self.exist?(cache_id)
		return FileTest.exist?(get_path(cache_id))
	end

	def self.get_path(cache_id)
		raise ArgumentError, "Invalid cache_id. (a-z 0-9 and _ are available)" unless /[a-z0-9_]+/ =~ cache_id

		return CACHE_DIR + @@prefix + cache_id
	end
end
