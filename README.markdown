## Abstract ##

Abst is Computational Algebra System written in pure Ruby.

## Installation ##

    gem install abst

## Usage ##

    require 'abst'
    
    p Abst.gcd(42, 30)      # => 6
    p Abst.isqrt(115)       # => 10 (floor of square root)
    p Abst.fibonacci(100)   # => 354224848179261915075 (100th Fibonacci number)
    p Abst.factorize(1000)  # => [[2, 3], [5, 3]]
    p 10.factorial          # => 3628800
    p 10.C 2                # => 45 (combination)
    # etc...
