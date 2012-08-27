require 'minitest/unit'
require 'minitest/autorun'
require 'abst'

class TC_Prime < MiniTest::Unit::TestCase
	def test_primes_list
		list = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
		assert_equal(list, Abst.primes_list[0...10])
	end

	def test_pseudoprime_test
		assert_equal(true, Abst.pseudoprime_test(3, 2))
		assert_equal(true, Abst.pseudoprime_test(5, 3))
		assert_equal(true, Abst.pseudoprime_test(7, 4))
		assert_equal(false, Abst.pseudoprime_test(4, 3))
		assert_equal(false, Abst.pseudoprime_test(15, 8))
	end

	def test_strong_pseudoprime_test
		assert_equal(true, Abst.strong_pseudoprime_test(3, 2))
		assert_equal(true, Abst.strong_pseudoprime_test(5, 3))
		assert_equal(true, Abst.strong_pseudoprime_test(7, 4))
		assert_equal(false, Abst.strong_pseudoprime_test(12, 5))
	end

	def test_miller_rabin
		assert_equal(true, Abst.miller_rabin(3))
		assert_equal(false, Abst.miller_rabin(4))
		assert_equal(true, Abst.miller_rabin(5))
		assert_equal(false, Abst.miller_rabin(6))
		assert_equal(true, Abst.miller_rabin(11))
		assert_equal(false, Abst.miller_rabin(169))
	end

	def test_n_minus_1
		assert_equal(true, Abst.n_minus_1(3))
		assert_equal(false, Abst.n_minus_1(4))
		assert_equal(true, Abst.n_minus_1(5))
		assert_equal(false, Abst.n_minus_1(6))
		assert_equal(true, Abst.n_minus_1(7))
		assert_equal(false, Abst.n_minus_1(561))
		assert_equal(true, Abst.n_minus_1(507526619771207))
	end

	def test_prime?
		assert_equal(false, Abst.prime?(1))
		assert_equal(true, Abst.prime?(2))
		assert_equal(true, Abst.prime?(3))
		assert_equal(false, Abst.prime?(4))
		assert_equal(true, Abst.prime?(5))
		assert_equal(false, Abst.prime?(6))
		assert_equal(true, Abst.prime?(7))
		assert_equal(false, Abst.prime?(8))
		assert_equal(false, Abst.prime?(9))
		assert_equal(false, Abst.prime?(10))
		assert_equal(true, Abst.prime?(11))
		assert_equal(false, Abst.prime?(12))
		assert_equal(true, Abst.prime?(13))
		assert_equal(true, Abst.prime?(17))
		assert_equal(false, Abst.prime?(1_373_653))
	end

	def test_trial_division
		assert_equal([[[2, 1]], 1], Abst.trial_division(2))
		assert_equal([[[3, 1]], 1], Abst.trial_division(3))
		assert_equal([[[2, 2]], 1], Abst.trial_division(4))
		assert_equal([[[5, 1]], 1], Abst.trial_division(5))
		assert_equal([[[2, 1], [3, 1]], 1], Abst.trial_division(6))
		assert_equal([[[11, 1]], 1], Abst.trial_division(11))
		assert_equal([[[13, 2]], 1], Abst.trial_division(169))
		assert_equal([[[2, 2], [231053, 1], [415039, 1]], 708806692316951],
			Abst.trial_division(4 * 231053 * 415039 * 70_880_669_231_6951, 500_000))
	end

	def test_differences_of_squares
		assert_equal([985109, 2993579], Abst.differences_of_squares(2949001615111))
		assert_equal([6576439, 8192167], Abst.differences_of_squares(53875286553313))
		assert_equal([4121987, 9553081], Abst.differences_of_squares(39377675691947))
	end

	def test_pollard_rho
		assert_equal(155240783, Abst.pollard_rho(3876131431000528283))
		assert_equal(2252849497, Abst.pollard_rho(5409492426475365797, 1, 2, 100_000))
		assert_equal(1264621003, Abst.pollard_rho(11781814522941624827, 1, 2, 100_000))
	end

	def test_p_minus_1
		assert_equal(3, Abst.p_minus_1(6, 10_000, 2))
		assert_equal(3292218043, Abst.p_minus_1(9530738504299322287, 10_000, 2))
		assert_equal(6042787811, Abst.p_minus_1(23916353875143281737, 10_000, 2))
		assert_equal(8228369521, Abst.p_minus_1(24559500716705748943, 10_000, 2))
		assert_equal(7046628167, Abst.p_minus_1(43381522922949440477, 10_000, 2))
		assert_equal(9571252001, Abst.p_minus_1(79670656009259581439, 10_000, 2))
		assert_equal(6135173419, Abst.p_minus_1(19256936255213267029, 10_000, 2))
	end

	def test_factorize
		assert_equal([[-1, 1]], Abst.factorize(-1))
		assert_equal([[0, 1]], Abst.factorize(0))
		assert_equal([[1, 1]], Abst.factorize(1))
		assert_equal([[2, 1]], Abst.factorize(2))
		assert_equal([[3, 1]], Abst.factorize(3))
		assert_equal([[2, 2]], Abst.factorize(4))
		assert_equal([[5, 1]], Abst.factorize(5))
		assert_equal([[2, 2], [3, 1]], Abst.factorize(12))
		assert_equal([[3, 4]], Abst.factorize(81))
		assert_equal([[2, 10]], Abst.factorize(1024))
		assert_equal([[-1, 1], [3, 1], [5, 3]], Abst.factorize(-375))
		assert_equal([[3, 1], [224743, 2]], Abst.factorize(151528248147))
		assert_equal([[1658414587, 1], [5856287651, 1]], Abst.factorize(5856287651 * 1658414587))
	end

	def test_eratosthenes_sieve
		assert_equal([2, 3, 5, 7], Abst.eratosthenes_sieve(10).to_a)
		assert_equal([2, 3, 5, 7, 11], Abst.eratosthenes_sieve(11).to_a)
		assert_equal([2, 3, 5, 7, 11], Abst.eratosthenes_sieve(12).to_a)
		assert_equal([2, 3, 5, 7, 11, 13, 17, 19], Abst.eratosthenes_sieve(20).to_a)
	end

	def test_consecutive_factorization
		rslt = Abst.consecutive_factorization(15)
		assert_equal({3=>[[3, 1]], 5=>[[5, 1]], 7=>[[7, 1]], 9=>[[3, 2]],
			11=>[[11, 1]], 13=>[[13, 1]], 15=>[[3, 1], [5, 1]]}, rslt)
		assert_equal(nil, rslt[0])
		assert_equal(nil, rslt[1])
		assert_equal([[2, 3]], rslt[8])
		assert_equal(nil, rslt[16])
	end

	def test_next_prime
		assert_equal(2, Abst.next_prime(-5))
		assert_equal(2, Abst.next_prime(0))
		assert_equal(2, Abst.next_prime(1))
		assert_equal(3, Abst.next_prime(2))
		assert_equal(5, Abst.next_prime(3))
		assert_equal(5, Abst.next_prime(4))
		assert_equal(7, Abst.next_prime(5))
		assert_equal(7, Abst.next_prime(6))
		assert_equal(11, Abst.next_prime(7))
		assert_equal(29, Abst.next_prime(23))
		assert_equal(101, Abst.next_prime(100))
		assert_equal(599993, Abst.next_prime(599983))
		assert_equal(900001, Abst.next_prime(899981))
	end

	def test_each_prime
		assert_equal([2, 3, 5, 7], (0..10).each_prime.to_a)
		assert_equal([11, 13, 17, 19], (11..20).each_prime.to_a)
		assert_equal([23, 29, 31, 37], (21...41).each_prime.to_a)
		assert_equal([23, 29, 31, 37, 41], (21..41).each_prime.to_a)
	end

	def test_phi
		assert_equal(1, Abst.phi(1))
		assert_equal(1, Abst.phi(2))
		assert_equal(2, Abst.phi(3))
		assert_equal(2, Abst.phi(4))
		assert_equal(4, Abst.phi(5))
		assert_equal(2, Abst.phi(6))
		assert_equal(6, Abst.phi(7))
		assert_equal(4, Abst.phi(8))
	end
end
