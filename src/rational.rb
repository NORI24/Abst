class Rational
	def self.one
		return Rational(1, 1)
	end

	def self.zero
		return Rational(0, 1)
	end

	def to_decimal_s(base = 10)
		raise ArgumentError, "invalid radix #{base}" if base < 2 or 36 < base

		# initialize
		quotient = []

		n = numerator.to_s(base).split('').map {|i| i.to_i}
		exp = 0
		while 0 == n.last
			n.pop
			exp += 1
		end
		d = denominator
		while 0 == d % base
			d /= base
			exp -= 1
		end
		t = n[0]

		# division loop
		i = 1
		loop do
			q, r = t.divmod(d)
			t = r * base + n[i].to_i

			quotient.push([q, nil])

			unless n[i]
				if 0 == t
					quotient.last[1] = 0
					break
				end
				break if quotient.map {|q, r| r}.include?(t)
				quotient.last[1] = t
			end

			i += 1
		end

		# format
		rslt = "0."

		zero_count = 0
		while 0 == quotient[0][0]
			zero_count += 1
			if t == quotient.shift[1]
				rslt += '('

				# rotate 0
				while 0 == quotient[0][0]
					quotient.push(quotient.shift)
					zero_count += 1
				end
				break
			end
		end
		exp += n.size - zero_count

		convert = "0123456789abcdefghijklmnopqrstuvwxyz"
		if 0 == quotient.last[1]
			rslt += quotient.inject('') do |r, i|
				r + convert[i[0]]
			end
		else
			quotient.each do |i|
				rslt += convert[i[0]]
				rslt += '(' if t == i[1]
			end
			rslt +=  ")"
		end
		rslt +=  "e" + exp.to_s unless 0 == exp

		return rslt
	end
end
