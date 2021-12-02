import misc

fn test_flags() {
	a := u32(1)
	b := u32(6)
	c := u32(15)

	eprint('A: ')
	misc.print_queue_flags(a)

	eprint('B ')
	misc.print_queue_flags(b)

	eprint('A | B ')
	misc.print_queue_flags(a | b)

	eprint('C ')
	misc.print_queue_flags(c)

	eprint('C & (A | B) ')
	misc.print_queue_flags(c & (a | b))

	assert a & b == c & (a & b)
}
