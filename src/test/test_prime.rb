require 'test/unit'
require 'abst'

class TC_Prime < Test::Unit::TestCase
	def test_primes_list
		list = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
		assert_equal(list, primes_list[0...10])
	end

	def test_pseudoprime_test
		assert_equal(true, pseudoprime_test(3, 2))
		assert_equal(true, pseudoprime_test(5, 3))
		assert_equal(true, pseudoprime_test(7, 4))
		assert_equal(false, pseudoprime_test(4, 3))
		assert_equal(false, pseudoprime_test(15, 8))
	end

	def test_strong_pseudoprime_test
		assert_equal(true, strong_pseudoprime_test(3, 2))
		assert_equal(true, strong_pseudoprime_test(5, 3))
		assert_equal(true, strong_pseudoprime_test(7, 4))
		assert_equal(false, strong_pseudoprime_test(12, 5))
	end

	def test_miller_rabin
		assert_equal(true, miller_rabin(3))
		assert_equal(false, miller_rabin(4))
		assert_equal(true, miller_rabin(5))
		assert_equal(false, miller_rabin(6))
		assert_equal(true, miller_rabin(11))
		assert_equal(false, miller_rabin(169))
	end

	def test_trial_division
		assert_equal([[[2, 1]], 1], trial_division(2))
		assert_equal([[[3, 1]], 1], trial_division(3))
		assert_equal([[[2, 2]], 1], trial_division(4))
		assert_equal([[[5, 1]], 1], trial_division(5))
		assert_equal([[[2, 1], [3, 1]], 1], trial_division(6))
		assert_equal([[[11, 1]], 1], trial_division(11))
		assert_equal([[[13, 2]], 1], trial_division(169))
	end

	def test_prime?
		assert_equal(false, prime?(1))
		assert_equal(true, prime?(2))
		assert_equal(true, prime?(3))
		assert_equal(false, prime?(4))
		assert_equal(true, prime?(5))
		assert_equal(false, prime?(6))
		assert_equal(true, prime?(7))
		assert_equal(false, prime?(8))
		assert_equal(false, prime?(9))
		assert_equal(false, prime?(10))
		assert_equal(true, prime?(11))
		assert_equal(false, prime?(12))
		assert_equal(true, prime?(13))
	end

	def test_differences_of_squares
		assert_equal([2993579, 985109], differences_of_squares(2949001615111))
		assert_equal([8192167, 6576439], differences_of_squares(53875286553313))
		assert_equal([9553081, 4121987], differences_of_squares(39377675691947))
	end

	def test_pollard_rho
		assert_equal(155240783, pollard_rho(3876131431000528283))
		assert_equal(2252849497, pollard_rho(5409492426475365797, 1, 2, 100_000))
		assert_equal(1264621003, pollard_rho(11781814522941624827, 1, 2, 100_000))
	end

	def test_p_minus_1
		assert_equal(3, p_minus_1(6, 10_000, 2))
		assert_equal(3292218043, p_minus_1(9530738504299322287, 10_000, 2))
		assert_equal(6042787811, p_minus_1(23916353875143281737, 10_000, 2))
		assert_equal(8228369521, p_minus_1(24559500716705748943, 10_000, 2))
		assert_equal(7046628167, p_minus_1(43381522922949440477, 10_000, 2))
		assert_equal(9571252001, p_minus_1(79670656009259581439, 10_000, 2))
		assert_equal(6135173419, p_minus_1(19256936255213267029, 10_000, 2))
	end

	def test_factorize
		assert_equal([[1, 1]], factorize(1))
		assert_equal([[2, 1]], factorize(2))
		assert_equal([[3, 1]], factorize(3))
		assert_equal([[2, 2]], factorize(4))
		assert_equal([[5, 1]], factorize(5))
		assert_equal([[2, 2], [3, 1]], factorize(12))
		assert_equal([[3, 4]], factorize(81))
		assert_equal([[2, 10]], factorize(1024))
	end

	def test_eratosthenes_sieve
		assert_equal([2, 3, 5, 7], eratosthenes_sieve(10).to_a)
		assert_equal([2, 3, 5, 7, 11], eratosthenes_sieve(11).to_a)
		assert_equal([2, 3, 5, 7, 11], eratosthenes_sieve(12).to_a)
		assert_equal([2, 3, 5, 7, 11, 13, 17, 19], eratosthenes_sieve(20).to_a)
	end

	def test_next_prime
		assert_equal(2, next_prime(-5))
		assert_equal(2, next_prime(0))
		assert_equal(2, next_prime(1))
		assert_equal(3, next_prime(2))
		assert_equal(5, next_prime(3))
		assert_equal(5, next_prime(4))
		assert_equal(7, next_prime(5))
		assert_equal(7, next_prime(6))
		assert_equal(11, next_prime(7))
		assert_equal(29, next_prime(23))
		assert_equal(101, next_prime(100))
	end

	def test_each_prime
		assert_equal([2, 3, 5, 7], (0..10).each_prime.to_a)
		assert_equal([11, 13, 17, 19], (11..20).each_prime.to_a)
		assert_equal([23, 29, 31, 37], (21...41).each_prime.to_a)
		assert_equal([23, 29, 31, 37, 41], (21..41).each_prime.to_a)
	end

	def test_phi
		assert_equal(1, phi(1))
		assert_equal(1, phi(2))
		assert_equal(2, phi(3))
		assert_equal(2, phi(4))
		assert_equal(4, phi(5))
		assert_equal(2, phi(6))
		assert_equal(6, phi(7))
		assert_equal(4, phi(8))
	end
end
