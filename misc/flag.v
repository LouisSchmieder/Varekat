module misc

pub fn print_queue_flags(flags u32) {
	mut bits := []bool{}
	for i in 0 .. 32 {
		a := flags & (0x01 << (31 - i)) != 0
		bits << a
	}

	for i in 0 .. 32 {
		if bits[i] {
			eprint('1')
		} else {
			eprint('0')
		}
		if (i + 1) % 4 == 0 {
			eprint(' ')
		}
	}
	eprintln('')
}