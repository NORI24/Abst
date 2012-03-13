Gem::Specification.new do |s|
	s.platform = Gem::Platform::RUBY
	s.summary = "Ruby based algebraic number theory system"
	s.name = 'abst'
	s.version = "0.2.0"
	s.author = "Yasunori Miyamoto"
	s.require_path = 'lib'
	s.files = Dir.glob("lib/**/*.rb")
	s.test_files = Dir.glob("test/**/*.rb")
	s.description = "prime,matrix, polynomial,etc"
end
