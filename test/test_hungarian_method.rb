require 'minitest/unit'
require 'minitest/autorun'
require 'abst'

class TC_HungarianMethod < MiniTest::Unit::TestCase
	def test_cover
		matrix = <<-EOS
			26 20  0  0 22  1 28 24
			 0  0 10 16  4 12  0  0
			26 20  0  0 22  1 28 24
			26 20  0  0 10  1 19 24
			 0  0 10 16  4 12  0  0
			 0  0 10 16  4 12  0  0
			 4 16 26  8  0  0  0  8
			 4 16 26  8  0  0  0  8
		EOS
		.split("\n").map {|row| row.split.map(&:to_i)}

		rows_cover, cols_cover = Abst::HungarianMethod.new(matrix).cover(matrix, 8.times.to_a, 8.times.to_a)
		assert_equal [1, 4, 5, 6, 7], rows_cover.sort
		assert_equal [2, 3], cols_cover.sort
	end

	def test_min
		matrix = <<-EOS
			26 20  0  0 22  1 28 24
			 0  0 10 16  4 12  0  0
			26 20  0  0 22  1 28 24
			26 20  0  0 10  1 19 24
			 0  0 10 16  4 12  0  0
			 0  0 10 16  4 12  0  0
			 4 16 26  8  0  0  0  8
			 4 16 26  8  0  0  0  8
		EOS
		.split("\n").map {|row| row.split.map(&:to_i)}

		hungarian = Abst::HungarianMethod.new(matrix)
		assert_equal [[0, 2], [1, 0], [2, 3], [3, 5], [4, 1], [5, 7], [6, 4], [7, 6]], hungarian.min_coordinates
		assert_equal 1, hungarian.min
	end

	def test_max
		matrix = <<-EOS
			  7  53 183 439 863 497 383 563  79 973 287  63 343 169 583
			627 343 773 959 943 767 473 103 699 303 957 703 583 639 913
			447 283 463  29  23 487 463 993 119 883 327 493 423 159 743
			217 623   3 399 853 407 103 983  89 463 290 516 212 462 350
			960 376 682 962 300 780 486 502 912 800 250 346 172 812 350
			870 456 192 162 593 473 915  45 989 873 823 965 425 329 803
			973 965 905 919 133 673 665 235 509 613 673 815 165 992 326
			322 148 972 962 286 255 941 541 265 323 925 281 601  95 973
			445 721  11 525 473  65 511 164 138 672  18 428 154 448 848
			414 456 310 312 798 104 566 520 302 248 694 976 430 392 198
			184 829 373 181 631 101 969 613 840 740 778 458 284 760 390
			821 461 843 513  17 901 711 993 293 157 274  94 192 156 574
			 34 124   4 878 450 476 712 914 838 669 875 299 823 329 699
			815 559 813 459 522 788 168 586 966 232 308 833 251 631 107
			813 883 451 509 615  77 281 613 459 205 380 274 302  35 805
		EOS
		.split("\n").map {|row| row.split.map(&:to_i)}

		hungarian = Abst::HungarianMethod.new(matrix)
		assert_equal [[0, 9], [1, 10], [2, 7], [3, 4], [4, 3], [5, 0], [6, 13], [7, 2], [8, 14],
			[9, 11], [10, 6], [11, 5], [12, 12], [13, 8], [14, 1]], hungarian.max_coordinates
		assert_equal 13938, hungarian.max


		matrix = <<-EOS
			42 42 40 40 42 42 40 40 42 40 42 42 42
			30 30 48 32 30 30 32 32 30 32 30 30 30
			72 72 40 40 72 72 40 40 72 60 72 72 72
			18 27 24 24 27 18 24 24 18 36 27 27 18
			24 24 28 28 24 36 28 28 24 28 24 24 24
			36 54 36 36 54 36 36 36 36 54 54 54 54
			36 36 32 32 36 36 32 32 36 48 36 36 36
			18 18 16 16 18 18 16 16 18 24 18 18 18
			24 24 54 36 24 24 36 36 24 36 24 24 24
			30 30 48 32 30 30 32 32 30 32 30 30 30
			54 54 24 24 54 54 24 24 54 36 54 54 54
			30 45 40 40 45 30 40 40 30 60 45 45 45
			90 90 56 56 90 90 56 56 90 84 90 90 90
			54 54 16 16 54 54 16 16 54 16 54 54 54
		EOS
		.split("\n").map {|row| row.split.map(&:to_i)}

		hungarian = Abst::HungarianMethod.new(matrix)
		assert_equal [[0, 3], [1, 6], [2, 0], [3, 1], [4, 5], [5, 4], [6, 8], [8, 2],
			[9, 7], [10, 10], [11, 9], [12, 11], [13, 12]], hungarian.max_coordinates
		assert_equal 641, hungarian.max


		matrix = <<-EOS
			32 30 48 30 30 32
			16 18 16 18 18 24
			48 36 32 36 36 48
			30 36 20 24 36 30
			36 24 54 24 24 36
			24 54 16 54 54 16
			28 24 28 24 24 28
			54 54 36 36 54 54
			60 45 40 30 45 60
			84 90 56 90 90 84
			36 54 24 54 54 36
			12 45 12 45 45 12
			36 27 24 18 27 36
		EOS
		.split("\n").map {|row| row.split.map(&:to_i)}

		hungarian = Abst::HungarianMethod.new(matrix)
		assert_equal [[4, 2], [5, 1], [7, 0], [8, 5], [9, 3], [10, 4]], hungarian.max_coordinates
		assert_equal 366, hungarian.max


		matrix = <<-EOS
			18 18 36 18 27 27 18 24 36 27 18 27 24
			24 24 36 24 24 24 24 36 36 24 24 24 36
			45 45 12 45 45 45 45 12 12 45 45 45 12
			72 72 60 72 72 72 72 40 60 72 72 72 40
			30 30 60 30 45 45 30 40 60 45 45 45 40
			36 36 48 36 36 36 36 32 48 36 36 36 32
			54 54 16 54 54 54 54 16 24 54 54 54 16
			30 30 32 30 30 30 30 32 32 30 30 30 32
		EOS
		.split("\n").map {|row| row.split.map(&:to_i)}

		hungarian = Abst::HungarianMethod.new(matrix)
		assert_equal [[0, 4], [1, 7], [2, 0], [3, 1], [4, 2], [5, 8], [6, 3], [7, 12]], hungarian.max_coordinates
		assert_equal 374, hungarian.max
	end
end
