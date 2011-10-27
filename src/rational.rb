class Rational
	def self.one
		return Rational(1, 1)
	end

	def self.zero
		return Rational(0, 1)
	end

	# to repeating decimal string
	def to_rds(base = 10)
		raise ArgumentError, "invalid radix #{base}" if base < 2 or 36 < base

		# initialize
		quotient = []

		n = numerator.to_s(base).split('').map(&:to_i)
		exp = 0
		while 0 == n.last
			n.pop
			exp += 1
		end
		d = denominator
		loop do
			q, r = d.divmod(base)
			break unless 0 == r
			d = q
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
				break if quotient.map(&:last).include?(t)
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
			rslt += quotient.map{|q| convert[q[0]]}.inject(&:+)
		else
			quotient.each do |q|
				rslt += convert[q[0]]
				rslt += '(' if t == q[1]
			end
			rslt +=  ")"
		end
		rslt +=  "e" + exp.to_s unless 0 == exp

		return rslt
	end

	# to decimal string
	def to_ds(length = 64, base = 10)
		raise ArgumentError, "invalid radix #{base}" if base < 2 or 36 < base

		# initialize
		quotient = []

		n = numerator.to_s(base).split('').map(&:to_i)
		exp = 0
		while 0 == n.last
			n.pop
			exp += 1
		end
		d = denominator
		loop do
			q, r = d.divmod(base)
			break unless 0 == r
			d = q
			exp -= 1
		end
		t = n[0]

		# division loop
		i = 1
		s = nil
		loop do
			q, r = t.divmod(d)
			t = r * base + n[i].to_i

			s = i - 1 if nil == s and q != 0
			quotient.push([q, nil])

			unless n[i]
				if 0 == t
					quotient.last[1] = 0
					break
				end
				break if s and i - s == length
				quotient.last[1] = t
			end

			i += 1
		end

		# format
		zero_count = 0
		while 0 == quotient[0][0]
			zero_count += 1
			if t == quotient.shift[1]
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
		rslt = "0." + quotient.map{|q| convert[q[0]]}.inject(&:+)
		rslt +=  "e" + exp.to_s unless 0 == exp

		return rslt
	end
end
