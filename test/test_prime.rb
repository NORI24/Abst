require 'test/unit'
require 'ant'

class TC_Prime < Test::Unit::TestCase
	def test_primes_list
		list = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
		assert_equal(list, ANT.primes_list[0...10])
	end

	def test_pseudoprime_test
		assert_equal(true, ANT.pseudoprime_test(3, 2))
		assert_equal(true, ANT.pseudoprime_test(5, 3))
		assert_equal(true, ANT.pseudoprime_test(7, 4))
		assert_equal(false, ANT.pseudoprime_test(4, 3))
		assert_equal(false, ANT.pseudoprime_test(15, 8))
	end

	def test_strong_pseudoprime_test
		assert_equal(true, ANT.strong_pseudoprime_test(3, 2))
		assert_equal(true, ANT.strong_pseudoprime_test(5, 3))
		assert_equal(true, ANT.strong_pseudoprime_test(7, 4))
		assert_equal(false, ANT.strong_pseudoprime_test(12, 5))
	end

	def test_miller_rabin
		assert_equal(true, ANT.miller_rabin(3))
		assert_equal(false, ANT.miller_rabin(4))
		assert_equal(true, ANT.miller_rabin(5))
		assert_equal(false, ANT.miller_rabin(6))
		assert_equal(true, ANT.miller_rabin(11))
		assert_equal(false, ANT.miller_rabin(169))
	end

	def test_n_minus_1
		assert_equal(true, ANT.n_minus_1(3))
		assert_equal(false, ANT.n_minus_1(4))
		assert_equal(true, ANT.n_minus_1(5))
		assert_equal(false, ANT.n_minus_1(6))
		assert_equal(true, ANT.n_minus_1(7))
		assert_equal(false, ANT.n_minus_1(561))
		assert_equal(true, ANT.n_minus_1(507526619771207))
	end

	def test_prime?
		assert_equal(false, ANT.prime?(1))
		assert_equal(true, ANT.prime?(2))
		assert_equal(true, ANT.prime?(3))
		assert_equal(false, ANT.prime?(4))
		assert_equal(true, ANT.prime?(5))
		assert_equal(false, ANT.prime?(6))
		assert_equal(true, ANT.prime?(7))
		assert_equal(false, ANT.prime?(8))
		assert_equal(false, ANT.prime?(9))
		assert_equal(false, ANT.prime?(10))
		assert_equal(true, ANT.prime?(11))
		assert_equal(false, ANT.prime?(12))
		assert_equal(true, ANT.prime?(13))
		assert_equal(true, ANT.prime?(17))
		assert_equal(false, ANT.prime?(1_373_653))
	end

	def test_trial_division
		assert_equal([[[2, 1]], 1], ANT.trial_division(2))
		assert_equal([[[3, 1]], 1], ANT.trial_division(3))
		assert_equal([[[2, 2]], 1], ANT.trial_division(4))
		assert_equal([[[5, 1]], 1], ANT.trial_division(5))
		assert_equal([[[2, 1], [3, 1]], 1], ANT.trial_division(6))
		assert_equal([[[11, 1]], 1], ANT.trial_division(11))
		assert_equal([[[13, 2]], 1], ANT.trial_division(169))
		assert_equal([[[2, 2], [231053, 1], [415039, 1]], 708806692316951],
			ANT.trial_division(4 * 231053 * 415039 * 70_880_669_231_6951, 500_000))
	end

	def test_differences_of_squares
		assert_equal([985109, 2993579], ANT.differences_of_squares(2949001615111))
		assert_equal([6576439, 8192167], ANT.differences_of_squares(53875286553313))
		assert_equal([4121987, 9553081], ANT.differences_of_squares(39377675691947))
	end

	def test_pollard_rho
		assert_equal(155240783, ANT.pollard_rho(3876131431000528283))
		assert_equal(2252849497, ANT.pollard_rho(5409492426475365797, 1, 2, 100_000))
		assert_equal(1264621003, ANT.pollard_rho(11781814522941624827, 1, 2, 100_000))
	end

	def test_p_minus_1
		assert_equal(3, ANT.p_minus_1(6, 10_000, 2))
		assert_equal(3292218043, ANT.p_minus_1(9530738504299322287, 10_000, 2))
		assert_equal(6042787811, ANT.p_minus_1(23916353875143281737, 10_000, 2))
		assert_equal(8228369521, ANT.p_minus_1(24559500716705748943, 10_000, 2))
		assert_equal(7046628167, ANT.p_minus_1(43381522922949440477, 10_000, 2))
		assert_equal(9571252001, ANT.p_minus_1(79670656009259581439, 10_000, 2))
		assert_equal(6135173419, ANT.p_minus_1(19256936255213267029, 10_000, 2))
	end

	def test_factorize
		assert_equal([[-1, 1]], ANT.factorize(-1))
		assert_equal([[0, 1]], ANT.factorize(0))
		assert_equal([[1, 1]], ANT.factorize(1))
		assert_equal([[2, 1]], ANT.factorize(2))
		assert_equal([[3, 1]], ANT.factorize(3))
		assert_equal([[2, 2]], ANT.factorize(4))
		assert_equal([[5, 1]], ANT.factorize(5))
		assert_equal([[2, 2], [3, 1]], ANT.factorize(12))
		assert_equal([[3, 4]], ANT.factorize(81))
		assert_equal([[2, 10]], ANT.factorize(1024))
		assert_equal([[-1, 1], [3, 1], [5, 3]], ANT.factorize(-375))
		assert_equal([[3, 1], [224743, 2]], ANT.factorize(151528248147))
	end

	def test_eratosthenes_sieve
		assert_equal([2, 3, 5, 7], ANT.eratosthenes_sieve(10).to_a)
		assert_equal([2, 3, 5, 7, 11], ANT.eratosthenes_sieve(11).to_a)
		assert_equal([2, 3, 5, 7, 11], ANT.eratosthenes_sieve(12).to_a)
		assert_equal([2, 3, 5, 7, 11, 13, 17, 19], ANT.eratosthenes_sieve(20).to_a)
	end

	def test_next_prime
		assert_equal(2, ANT.next_prime(-5))
		assert_equal(2, ANT.next_prime(0))
		assert_equal(2, ANT.next_prime(1))
		assert_equal(3, ANT.next_prime(2))
		assert_equal(5, ANT.next_prime(3))
		assert_equal(5, ANT.next_prime(4))
		assert_equal(7, ANT.next_prime(5))
		assert_equal(7, ANT.next_prime(6))
		assert_equal(11, ANT.next_prime(7))
		assert_equal(29, ANT.next_prime(23))
		assert_equal(101, ANT.next_prime(100))
		assert_equal(599993, ANT.next_prime(599983))
		assert_equal(900001, ANT.next_prime(899981))
	end

	def test_each_prime
		assert_equal([2, 3, 5, 7], (0..10).each_prime.to_a)
		assert_equal([11, 13, 17, 19], (11..20).each_prime.to_a)
		assert_equal([23, 29, 31, 37], (21...41).each_prime.to_a)
		assert_equal([23, 29, 31, 37, 41], (21..41).each_prime.to_a)
	end

	def test_phi
		assert_equal(1, ANT.phi(1))
		assert_equal(1, ANT.phi(2))
		assert_equal(2, ANT.phi(3))
		assert_equal(2, ANT.phi(4))
		assert_equal(4, ANT.phi(5))
		assert_equal(2, ANT.phi(6))
		assert_equal(6, ANT.phi(7))
		assert_equal(4, ANT.phi(8))
	end
end
