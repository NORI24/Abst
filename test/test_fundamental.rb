require 'minitest/autorun'
require 'abst'

class TC_Fundamental < MiniTest::Test
	def test_right_left_power
		assert_equal(1, Abst.right_left_power(5, 0))
		assert_equal(1024, Abst.right_left_power(2, 10))
		assert_equal(24, Abst.right_left_power(2, 10, 100))
		# Float
		assert_equal(1.0 / 1024, Abst.right_left_power(2.0, -10))
		# Rational
		assert_equal(Rational(1024, 59049), Abst.right_left_power(Rational(2, 3), 10))
		assert_equal(Rational(59049, 1024), Abst.right_left_power(Rational(2, 3), -10))
		# Complex
		assert_equal(Complex('1/32i'), Abst.right_left_power(Complex('1/2+1/2i'), 10))
		assert_equal(Complex('-32i'), Abst.right_left_power(Complex('1/2+1/2i'), -10))
	end

	def test_left_right_power
		assert_equal(1, Abst.left_right_power(5, 0))
		assert_equal(1024, Abst.left_right_power(2, 10))
		assert_equal(24, Abst.left_right_power(2, 10, 100))
		# Float
		assert_equal(1.0 / 1024, Abst.left_right_power(2.0, -10))
		# Rational
		assert_equal(Rational(1024, 59049), Abst.left_right_power(Rational(2, 3), 10))
		assert_equal(Rational(59049, 1024), Abst.left_right_power(Rational(2, 3), -10))
		# Complex
		assert_equal(Complex('1/32i'), Abst.left_right_power(Complex('1/2+1/2i'), 10))
		assert_equal(Complex('-32i'), Abst.left_right_power(Complex('1/2+1/2i'), -10))
	end

	def test_left_right_base2k_power
		assert_equal(1, Abst.left_right_base2k_power(5, 0))
		assert_equal(1024, Abst.left_right_base2k_power(2, 10))
		assert_equal(24, Abst.left_right_base2k_power(2, 10, 100))
		assert_equal(24, Abst.left_right_base2k_power(2, 10, 100, 1))
		assert_equal(8212890625, Abst.left_right_base2k_power(5, 2 ** 100, 10 ** 10))
		# Float
		assert_equal(1.0 / 1024, Abst.left_right_base2k_power(2.0, -10))
		assert_equal(1.0 / 1024, Abst.left_right_base2k_power(2.0, -10, nil, 2))
		# Rational
		assert_equal(Rational(1024, 59049), Abst.left_right_base2k_power(Rational(2, 3), 10))
		assert_equal(Rational(59049, 1024), Abst.left_right_base2k_power(Rational(2, 3), -10))
		# Complex
		assert_equal(Complex('1/32i'), Abst.left_right_base2k_power(Complex('1/2+1/2i'), 10))
		assert_equal(Complex('-32i'), Abst.left_right_base2k_power(Complex('1/2+1/2i'), -10))
	end

	def test_gcd
		assert_equal(1, Abst.gcd(3, 4))
		assert_equal(7, Abst.gcd(14, 21))
		assert_equal(2, Abst.gcd(150, 376))
		assert_equal(32, Abst.gcd(1024, 32))
	end

	def test_lcm
		assert_equal 1, Abst.lcm(1)
		assert_equal 2, Abst.lcm(2)
		assert_equal 6, Abst.lcm(2, 3)
		assert_equal 12, Abst.lcm(4, 6)
		assert_equal 0, Abst.lcm(0, 3)
		assert_equal 12, Abst.lcm(2, 3, 4)
		assert_equal 60, Abst.lcm(6, 10, 12)
	end

	def test_lehmer_gcd
		assert_equal(7, Abst.lehmer_gcd(14, 21))
		assert_equal(4294967311, Abst.lehmer_gcd(4294967311 * 2, 4294967311 * 3))

		10.times do
			a = rand(1 << (Abst::BASE_BYTE << 5))
			b = rand(1 << (Abst::BASE_BYTE << 5))
			assert_equal(Abst.gcd(a, b), Abst.lehmer_gcd(a, b))
		end
	end

	def test_binary_gcd
		assert_equal(1, Abst.binary_gcd(3, 4))
		assert_equal(7, Abst.binary_gcd(14, 21))
		assert_equal(2, Abst.binary_gcd(150, 376))
		assert_equal(32, Abst.binary_gcd(1024, 32))

		10.times do
			a = rand(1 << (Abst::BASE_BYTE << 5))
			b = rand(1 << (Abst::BASE_BYTE << 5))
			assert_equal(Abst.gcd(a, b), Abst.binary_gcd(a, b))
		end
	end

	def test_extended_gcd
		assert_equal([-1, 1, 1], Abst.extended_gcd(3, 4))
		assert_equal([-1, 1, 7], Abst.extended_gcd(14, 21))
		assert_equal([-5, 2, 2], Abst.extended_gcd(150, 376))
		assert_equal([0, 1, 32], Abst.extended_gcd(1024, 32))

		10.times do
			a = rand(10 ** 15)
			b = rand(10 ** 15)

			u, v, d = Abst.extended_gcd(a, b)
			assert_equal(Abst.gcd(a, b), d)
			assert_equal(d, a * u + b * v)
		end
	end

	def test_extended_lehmer_gcd
		assert_equal([-1, 1, 1], Abst.extended_lehmer_gcd(3, 4))
		assert_equal([-1, 1, 7], Abst.extended_lehmer_gcd(14, 21))
		assert_equal([-5, 2, 2], Abst.extended_lehmer_gcd(150, 376))
		assert_equal([0, 1, 32], Abst.extended_lehmer_gcd(1024, 32))

		10.times do
			a = rand(1 << (Abst::BASE_BYTE << 5))
			b = rand(1 << (Abst::BASE_BYTE << 5))

			u, v, d = Abst.extended_lehmer_gcd(a, b)
			assert_equal(Abst.gcd(a, b), d)
			assert_equal(d, a * u + b * v)
		end
	end

	def test_extended_binary_gcd
		test_cases = [[3, 4, 1], [14, 21, 7], [150, 376, 2], [1024, 32, 32]]

		test_cases.each do |a, b, gcd|
			u, v, d = Abst.extended_binary_gcd(a, b)
			assert_equal(gcd, d)
			assert_equal(d, a * u + b * v)
		end

		10.times do
			a = rand(1 << (Abst::BASE_BYTE << 5))
			b = rand(1 << (Abst::BASE_BYTE << 5))

			u, v, d = Abst.extended_binary_gcd(a, b)
			assert_equal(Abst.gcd(a, b), d)
			assert_equal(d, a * u + b * v)
		end
	end

	def test_inverse
		assert_equal(1, Abst.inverse(1, 3))
		assert_equal(2, Abst.inverse(2, 3))
		assert_equal(4, Abst.inverse(2, 7))
		assert_equal(14, Abst.inverse(11, 17))
		assert_equal(14, Abst.inverse(-6, 17))
	end

	def test_chinese_remainder_theorem
		assert_equal(23, Abst.chinese_remainder_theorem([[1, 2], [2, 3], [3, 5]]))
		assert_equal(48, Abst.chinese_remainder_theorem([[6, 7], [3, 9]]))
	end

	def test_continued_fraction
		assert_equal([[0, 2], []], Abst.continued_fraction(1, 2, 1, 2))
		assert_equal([[0], [2, 3]], Abst.continued_fraction(1, 2, 1, 3))
		assert_equal([[0, 1], [5, 12]], Abst.continued_fraction(5, 6, 12, 13))
	end

	def test_primitive_root
		assert_equal(2, Abst.primitive_root(3))
		assert_equal(2, Abst.primitive_root(5))
		assert_equal(3, Abst.primitive_root(7))
		assert_equal(2, Abst.primitive_root(11))
		assert_equal(2, Abst.primitive_root(13))
		assert_equal(3, Abst.primitive_root(17))
		assert_equal(2, Abst.primitive_root(19))
		assert_equal(5, Abst.primitive_root(23))
		assert_equal(2, Abst.primitive_root(29))
		assert_equal(3, Abst.primitive_root(31))
		assert_equal(2, Abst.primitive_root(37))
		assert_equal(6, Abst.primitive_root(41))
	end

	def test_kronecker_symbol
		assert_equal(1, Abst.kronecker_symbol(-1, 0))
		assert_equal(1, Abst.kronecker_symbol(1, 0))
		assert_equal(0, Abst.kronecker_symbol(2, 0))
		assert_equal(0, Abst.kronecker_symbol(8, 0))
		assert_equal(0, Abst.kronecker_symbol(13, 0))
		assert_equal(0, Abst.kronecker_symbol(8, 12))
		assert_equal(-1, Abst.kronecker_symbol(13, 2))
		assert_equal(1, Abst.kronecker_symbol(15, 2))
		assert_equal(-1, Abst.kronecker_symbol(2, 3))
		assert_equal(1, Abst.kronecker_symbol(2, 7))
		assert_equal(-1, Abst.kronecker_symbol(3, 7))
		assert_equal(-1, Abst.kronecker_symbol(5, 7))
		assert_equal(1, Abst.kronecker_symbol(13, 12))
		assert_equal(-1, Abst.kronecker_symbol(13, 24))
		assert_equal(1, Abst.kronecker_symbol(4, 13))
		assert_equal(1, Abst.kronecker_symbol(724, -1))
		assert_equal(-1, Abst.kronecker_symbol(-724, -1))
		assert_equal(0, Abst.kronecker_symbol(548, 312))
		assert_equal(-1, Abst.kronecker_symbol(12345, 331))
		assert_equal(-1, Abst.kronecker_symbol(1001, 9907))
		assert_equal(1, Abst.kronecker_symbol(52341889, 31234212))

		a = 99643729781594451042868396167846501500230472387591107578143790780742788645801332383676638714231004135318519027831692615782047224443109967659091408007855678348418498337714611173177406989254270181688716945565274032789703
		b = 31267693914367505876627950752402860790982923001346570977067972147547243618434775100948874049098069122150588347330506599648051934242427953832849754314645299350774689759824194221025163955934019353362115252842755189364025771509757431
		assert_equal(-1, Abst.kronecker_symbol(a, b))

		a = 7187008801553024317502507584680801045947513443501530090606525215123945391329031252162272007600667345682610936718616699859719659137624739633380523384569660677495816031070163549368448824130188486965172598282867020003609075202255299904512333540079873642504661763660475
		b = 9390890125406356897547325530524014170880665334953972291198413925482476004521494203423987990880877752271210934990828148043157880469054299133817519741865133360375031870740979505090858933993543064540721325460139539342114216062420
		assert_equal(0, Abst.kronecker_symbol(a, b))
	end

	def test_mod_sqrt
		test = proc do |n, p, exp|
			rslt = exp ? Abst.mod_sqrt(n, p, exp) : Abst.mod_sqrt(n, p)
			if Abst.kronecker_symbol(n, p) == -1
				assert_equal(nil, rslt)
			elsif exp
				assert_equal(n % (p ** exp), rslt ** 2 % (p ** exp))
			else
				assert_equal(n % p, rslt ** 2 % p)
			end
		end

		test.call(2, 5)
		test.call(2, 7)
		test.call(21, 7)
		test.call(2, 11)
		test.call(3, 11)
		test.call(2, 13)
		test.call(3, 13)
		test.call(2, 17)
		test.call(17 * 3, 17)

		test.call(2, 7, 2)
		test.call(12, 97, 3)
	end

	def test_cornacchia
		test = lambda do |d, p, expect|
			rslt = Abst.cornacchia(d, p)
			if expect
				assert(rslt)
				x, y = rslt
				assert_equal(p, x ** 2 + d * y ** 2)
			else
				assert(nil == rslt)
			end
		end

		test.call(1, 5, true)
		test.call(1, 13, true)
		test.call(1, 17, true)
		test.call(1, 29, true)
		test.call(1, 53, true)
		test.call(7, 53, true)
		test.call(1, 19, false)
	end

	def test_modified_cornacchia
		test = lambda do |d, p, expect|
			rslt = Abst.modified_cornacchia(d, p)
			if expect
				assert(rslt)
				x, y = rslt
				assert_equal(p << 2, x ** 2 - d * y ** 2)
			else
				assert(nil == rslt)
			end
		end

		test.call(-7, 2, true)
		test.call(-4, 2, true)
		test.call(-3, 2, false)
		test.call(-7, 3, false)
		test.call(-4, 5, true)
	end

	def test_isqrt
		assert_equal(1, Abst.isqrt(1))
		assert_equal(1, Abst.isqrt(2))
		assert_equal(1, Abst.isqrt(3))
		assert_equal(2, Abst.isqrt(4))
		assert_equal(3, Abst.isqrt(15))
		assert_equal(4, Abst.isqrt(16))
		assert_equal(5, Abst.isqrt(25))
		assert_equal(7, Abst.isqrt(50))
		assert_equal(9, Abst.isqrt(97))
		assert_equal(10, Abst.isqrt(100))
		assert_equal(1553171, Abst.isqrt(2412342342347))

		10.times do
			n = rand(10 ** 20) + 1
			sroot = Abst.isqrt(n)
			assert(sroot ** 2 <= n && n < (sroot + 1) ** 2)
		end
	end

	def test_iroot
		assert_equal(1, Abst.iroot(1, 2))
		assert_equal(1, Abst.iroot(2, 2))
		assert_equal(1, Abst.iroot(3, 2))
		assert_equal(2, Abst.iroot(4, 2))

		assert_equal(1, Abst.iroot(1, 3))
		assert_equal(1, Abst.iroot(2, 3))
		assert_equal(1, Abst.iroot(7, 3))
		assert_equal(2, Abst.iroot(8, 3))
		assert_equal(2, Abst.iroot(26, 3))
		assert_equal(3, Abst.iroot(27, 3))

		assert_equal([1, 1], Abst.iroot(1, 4, true))
		assert_equal([1, 1], Abst.iroot(15, 4, true))
		assert_equal([2, 16], Abst.iroot(16, 4, true))
		assert_equal([2, 16], Abst.iroot(80, 4, true))
		assert_equal(3, Abst.iroot(81, 4))

		10.times do
			n = rand(10 ** 20) + 1
			pow = rand(40) + 1
			proot = Abst.iroot(n, pow)
			assert(proot ** pow <= n && n < (proot + 1) ** pow)
		end
	end

	def test_prime_power?
		assert_equal(2, Abst.prime_power?(2))
		assert_equal(3, Abst.prime_power?(3))
		assert_equal(2, Abst.prime_power?(4))
		assert_equal(false, Abst.prime_power?(6))
		assert_equal(2, Abst.prime_power?(8))
		assert_equal(17, Abst.prime_power?(17))
		assert_equal(false, Abst.prime_power?(94))
		assert_equal(13, Abst.prime_power?(169))
		assert_equal(3, Abst.prime_power?(243))
	end

	def test_power_detection
		assert_equal([1, 1], Abst.power_detection(1))
		assert_equal([2, 1], Abst.power_detection(2))
		assert_equal([3, 1], Abst.power_detection(3))
		assert_equal([2, 2], Abst.power_detection(4))
		assert_equal([5, 1], Abst.power_detection(5))
		assert_equal([2, 3], Abst.power_detection(8))
		assert_equal([4, 2], Abst.power_detection(16, false))
		assert_equal([2, 4], Abst.power_detection(16, true))
		assert_equal([2 ** 21, 3], Abst.power_detection(2 ** 63, false))
		assert_equal([2, 63], Abst.power_detection(2 ** 63, true))
		assert_equal([9, 2], Abst.power_detection(81, false))
		assert_equal([3, 4], Abst.power_detection(81, true))
	end

	def test_ilog2
		assert_equal(0, Abst.ilog2(1))
		assert_equal(1, Abst.ilog2(2))
		assert_equal(1, Abst.ilog2(3))
		assert_equal(2, Abst.ilog2(4))
		assert_equal(2, Abst.ilog2(5))
		assert_equal(7, Abst.ilog2(2 ** 8 - 1))
		assert_equal(8, Abst.ilog2(2 ** 8))
		assert_equal(31, Abst.ilog2(2 ** 32 - 1))
		assert_equal(32, Abst.ilog2(2 ** 32))
		assert_equal(63, Abst.ilog2(2 ** 64 - 1))
		assert_equal(64, Abst.ilog2(2 ** 64))
	end

	def test_powers_of_2
		list = [1, 2, 4, 8, 16, 32, 64, 128, 256]

		assert_equal(list, Abst.powers_of_2[0..8])
		assert_equal(Abst::BASE_BYTE * 8, Abst.powers_of_2.size)
	end

	def test_continued_fraction_of_sqrt
		assert_equal([1, []], Abst.continued_fraction_of_sqrt(1))
		assert_equal([1, [2]], Abst.continued_fraction_of_sqrt(2))
		assert_equal([1, [1, 2]], Abst.continued_fraction_of_sqrt(3))
		assert_equal([2, []], Abst.continued_fraction_of_sqrt(4))
		assert_equal([2, [4]], Abst.continued_fraction_of_sqrt(5))
		assert_equal([2, [2, 4]], Abst.continued_fraction_of_sqrt(6))
		assert_equal([2, [1, 1, 1, 4]], Abst.continued_fraction_of_sqrt(7))
		assert_equal([2, [1, 4]], Abst.continued_fraction_of_sqrt(8))
		assert_equal([3, []], Abst.continued_fraction_of_sqrt(9))
		assert_equal([3, [6]], Abst.continued_fraction_of_sqrt(10))
		assert_equal([3, [3, 6]], Abst.continued_fraction_of_sqrt(11))
		assert_equal([3, [2, 6]], Abst.continued_fraction_of_sqrt(12))
		assert_equal([3, [1, 1, 1, 1, 6]], Abst.continued_fraction_of_sqrt(13))
	end

	def test_bhaskara_brouncker
		assert_equal([1, 1], Abst.bhaskara_brouncker(2))
		assert_equal([2, 1], Abst.bhaskara_brouncker(3))
		assert_equal([2, 1], Abst.bhaskara_brouncker(5))
		assert_equal([5, 2], Abst.bhaskara_brouncker(6))
		assert_equal([8, 3], Abst.bhaskara_brouncker(7))
		assert_equal([29718, 3805], Abst.bhaskara_brouncker(61))
		assert_equal([8890182, 851525], Abst.bhaskara_brouncker(109))
	end

	def test_pythagorean
		assert_equal(0, Abst.pythagorean(-1).to_a.size)
		assert_equal(0, Abst.pythagorean(0).to_a.size)
		assert_equal(0, Abst.pythagorean(1).to_a.size)
		assert_equal(0, Abst.pythagorean(4).to_a.size)
		assert_equal(1, Abst.pythagorean(5).to_a.size)
		assert_equal(16, Abst.pythagorean(100).to_a.size)
		assert_equal(1593, Abst.pythagorean(10000).to_a.size)

		10.times do
			max_c = rand(10 ** 4)
			rslt = Abst.pythagorean(max_c).to_a
			if rslt.empty?
				assert(max_c <= 4)
			else
				a, b, c = rslt.sample
				assert(a ** 2 + b ** 2 == c ** 2)
			end
		end
	end
end
