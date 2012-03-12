module Abst
	class Cache
		PREFIX = 'abst_cache_'
		CACHE_DIR = CACHE_DIR

		def self.mkdir(dir)
			pdir = File.dirname(dir)
			mkdir(pdir) unless FileTest.exist?(pdir)
			Dir::mkdir(dir)
		end

		def self.[]=(cache_id, data)
			if nil == data
				delete(cache_id)
				return
			end

			path = get_path(cache_id)
			dir = File.dirname(path)

			mkdir(dir) unless FileTest.exist?(dir)
			open(path, "w") {|io| Marshal.dump(data, io)}
		end

		def self.[](cache_id)
			path = get_path(cache_id)

			return nil unless FileTest.exist?(path)
			open(path) {|io| return Marshal.load(io)}
		end

		def self.delete(cache_id)
			path = get_path(cache_id)

			File.delete(path) if FileTest.exist?(path)
		end

		def self.clear
			raise NotImplementedError
		end

		def self.exist?(cache_id)
			return FileTest.exist?(get_path(cache_id))
		end

		def self.get_path(cache_id)
			cache_id = cache_id.to_s
			unless /^[a-z0-9_]+$/ =~ cache_id
				raise ArgumentError, "Invalid cache_id. (Only a-z 0-9 and _ are available)"
			end

			return self::CACHE_DIR + self::PREFIX + cache_id
		end
	end

	class SystemCache < Cache
		PREFIX = ''
		CACHE_DIR = DATA_DIR
	end
end
