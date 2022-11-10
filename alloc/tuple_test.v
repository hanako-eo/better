module alloc

import result

fn test_tuple() {
	t := make_tuple('test')

	assert t.len == 1
	assert t.get<string>(0).is_some()
	assert t.get<int>(0).is_noth()

	mut x := ''
	assert t.pick<string>(mut x, 0).is_success()
	assert x == 'test'

	mut y := 1
	assert t.pick<int>(mut y, 0).is_fail() // == fail<TupleError>(TupleError.wrong_type)
	assert y == 1
}
