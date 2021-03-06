class Integer
  class << self
    def zero
      return 0
    end

    def one
      return 1
    end

    def *(other)
      raise ArgumentError unless other.kind_of?(self)
      Abst::IntegerIdeal.new(other)
    end

    def /(other)
      if other.kind_of?(Integer)
        other = Integer * other
      else
        raise ArgumentError unless other.kind_of?(Abst::IntegerIdeal)
      end
      return residue_class(other)
    end

    def coerce(other)
      return [self, other]
    end

    def to_tex
      return "\\mathbb{Z}"
    end
  end

  def bit_size
    return Abst.ilog2(self) + 1
  end

  # Return:: formatted string
  def to_fs
    return self.to_s.gsub(/(?<=\d)(?=(\d\d\d)+$)/, ' ')
  end

  # Param::  non-negative integer self
  # Return:: factorial self!
  def factorial
    return 2.upto(self).inject(1, &:*)
  end
  alias :! :factorial

  def inverse
    return 1 / Rational(self)
  end

  # Param::  prime
  # Return:: self! mod prime
  def pmod_factorial(prime)
    return 2.upto(self).inject(1) {|r, i| r * i % prime}
  end

  # Param::  prime
  # Return:: integer f > 0 and e >= 0 s.t.
  #          prime ** e || self! and
  #          f == self! / (prime ** e) % prime
  def extended_pmod_factorial(prime)
    q, r = self.divmod prime
    fac = q.even? ? 1 : prime - 1
    fac = fac * r.pmod_factorial(prime) % prime

    a = nil
    e = q
    if prime <= q
      a, b = q.extended_pmod_factorial(prime)
      e += b
    else
      a = q.pmod_factorial(prime)
    end
    fac = fac * a % prime

    return fac, e
  end

  def combination(r)
    r = self - r if self - r < r

    if r <= 0
      return r.zero? ? 1 : 0
    end

    return 2.upto(r).inject(self) {|rslt, i| rslt * (self - i + 1) / i}
  end
  alias :C :combination

  def pmod_combination(r, prime)
    f1, e1 = self.extended_pmod_factorial(prime)
    f2, e2 = r.extended_pmod_factorial(prime)
    f3, e3 = (self - r).extended_pmod_factorial(prime)

    return 0 if e2 + e3 < e1
    return f1 * Abst.inverse(f2 * f3, prime) % prime
  end

  def repeated_combination(r)
    return (self + r - 1).combination(r)
  end
  alias :H :repeated_combination

  # @param positive integer m > 1
  # @return boolean whether self is power of m or not
  def power_of?(m)
    n = self
    until 1 == n
      n, r = n.divmod(m)
      return false unless 0 == r
    end

    return true
  end

  # Triangle numbers are generated by the formula, T_n = n * (n + 1) / 2.
  # The first ten triangle numbers are:
  #     1, 3, 6, 10, 15, 21, 28, 36, 45, 55, ...
  # Return:: integer n s.t. self == T_n if exist else false
  def triangle?
    return false unless r = ((self << 3) + 1).square?
    return false unless (r - 1).even?

    return (r - 1) >> 1
  end

  def square
    self ** 2
  end

  def cube
    self ** 3
  end

  def sqrt
    Math.sqrt(self)
  end

  @@square_check_array = {
    11=>[true, true, false, true, true, true, false, false, false, true, false],
    63=>[true, true, false, false, true, false, false, true, false, true, false, false, false, false, false, false, true, false, true, false, false, false, true, false, false, true, false, false, true, false, false, false, false, false, false, false, true, true, false, false, false, false, false, true, false, false, true, false, false, true, false, false, false, false, false, false, false, false, true,false, false, false, false],
    64=>[true, true, false, false, true, false, false, false, false, true, false, false, false, false, false, false, true, true, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, true, false, false, false, false, true, false, false, false, false, false, false,false, true, false, false, false, false, false, false, false, true, false, false, false, false, false, false],
    65=>[true, true, false, false, true, false, false, false, false, true, true, false, false, false, true, false, true, false, false, false, false, false, false, false, false, true, true, false, false, true, true, false, false, false, false, true, true, false, false, true, true, false, false, false, false, false, false, false, false, true, false, true, false, false, false, true, true, false, false, false, false, true, false, false, true]
  }

  # Test whether self is a square number or not
  # Param::  positive integer self
  # Return:: square root of self if self is square else false
  def square?
    # 64
    t = self & 63
    return false unless @@square_check_array[64][t]

    r = self % 45045  # == 63 * 65 * 11
    [63, 65, 11].each do |c|
      return false unless @@square_check_array[c][r % c]
    end

    q = Abst.isqrt(self)
    return false unless q ** 2 == self

    return q
  end

  #@slow
  # Param::  positive integer self
  # Return:: true if self is squarefree, false otherwise
  def squarefree?
    n = self
    if n.even?
      return false if 0 == n[1]
      n >>= 1
    end

    return true if self <= 3
    return false if self.square?

    pl = Abst.precomputed_primes

    # trial division
    limit = Abst.isqrt(n)
    1.upto(pl.size - 1).each do |i|
      d = pl[i]
      return true if limit < d

      if n % d == 0
        n /= d
        return false if n % d == 0
        limit = Abst.isqrt(n)
      end
    end

    d = pl.last + 2
    loop do
      return true if limit < d

      if n % d == 0
        n /= d
        return false if n % d == 0
        limit = Abst.isqrt(n)
      end

      d += 2
    end
  end

  # Pentagonal numbers are generated by the formula, P_n = n * (3 * n - 1) / 2.
  # The first ten pentagonal numbers are:
  #     1, 5, 12, 22, 35, 51, 70, 92, 117, 145, ...
  # Return:: integer n s.t. self == P_n if exist else false
  def pentagonal?
    return false unless r = (24 * self + 1).square?

    q, r = (1 + r).divmod(6)
    return false unless 0 == r

    return q
  end

  # Hexagonal numbers are generated by the formula, H_n = n * (2 * n - 1)
  # The first ten hexagonal numbers are:
  #     1, 6, 15, 28, 45, 66, 91, 120, 153, 190, ...
  # Return:: integer n s.t. self == H_n if exist else false
  def hexagonal?
    return false unless r = ((self << 3) + 1).square?
    return false unless 0 == (1 + r) & 3

    return (1 + r) >> 2
  end

  # Heptagonal numbers are generated by the formula, P7_n = n * (5 * n - 3) / 2
  # The first ten heptagonal numbers are:
  #     1, 7, 18, 34, 55
  # Return:: integer n s.t. self == P7_n if exist else false
  def heptagonal?
    return false unless r = (self * 40 + 9).square?

    q, r = (3 + r).divmod(10)
    return false unless 0 == r

    return q
  end

  # Octagonal numbers are generated by the formula, P8_n = n * (3 * n - 2)
  # The first ten octagonal numbers are:
  #     1, 8, 21, 40, 65, ...
  # Return:: integer n s.t. self == P7_n if exist else false
  def octagonal?
    return false unless r = (self * 3 + 1).square?

    q, r = (1 + r).divmod(3)
    return false unless 0 == r

    return q
  end
end

module Abst
  Z = Integer

  class IntegerIdeal
    attr_reader :n

    def initialize(n)
      @n = n
    end

    def +(other)
      self.class.new(Abst.gcd(@mod, other.mod))
    end

    def *(other)
      self.class.new(@mod * other.mod)
    end

    def &(other)
      self.class.new(Abst.lcm(@mod, other.mod))
    end

    def to_s
      return "IntegerIdeal #{@n}Z"
    end
    alias inspect to_s

    def to_tex
      return "#{@n}#{Z.to_tex}"
    end
  end

  class IntegerResidueRing
    class << self
      attr_reader :mod

      def zero
        return self.new(0)
      end

      def one
        return self.new(1)
      end

      def order(op = :+)
        case op
        when :+
          return @mod
        when :*
          @order = phi(@mod) unless defined?(@order)
          return @order
        end

        raise ArgumentError, "unrecognized argument #{op} was specified"
      end
      alias cardinality order

      def to_s
        return "Z / #{@mod}Z"
      end

      def to_tex
        z = Z.to_tex
        return z + " / #{@mod}" + z
      end
    end

    attr_reader :n

    def initialize(n)
      @n = n % self.class.mod
    end

    [:+, :-, :*].each do |op|
      define_method(op) do |other|
        return self.class.new(@n.__send__(op, other.to_i))
      end
    end

    def ==(other)
      return false unless self.class.superclass == other.class.superclass
      return false unless self.class.mod == other.class.mod
      return @n == other.n
    end

    def inverse
      return self.class.new(Abst.inverse(@n, self.class.mod))
    end

    def order(op)
      mod = self.class.mod

      case op
      when :+
        return mod / gcd(@n, mod)
      when :*
        raise ArgumentError, "#{self} is not invertible" unless 1 == gcd(@n, mod)
        return element_order(self, self.class.order(op))
      end

      raise ArgumentError, "unrecognized argument #{op} was specified"
    end

    def to_s
      return "#{@n} (mod #{self.class.mod})"
    end
    alias inspect to_s

    def to_i
      return @n
    end

    include Abst::Ring
  end

  class IntegerResidueField < IntegerResidueRing
    class << self
      def order(op = :+)
        return @mod - 1 if :* == op
        return super
      end
    end

    def inverse
      return self.class.new(Abst.inverse(@n, self.class.mod))
    end

    def /(other)
      return self.class.new(@n * other.inverse.n)
    end
  end
end
