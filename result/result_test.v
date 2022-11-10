module result

fn test_result_booleans_operators() {
	// or
	assert ok<int, string>(0).@or(ok<int, string>(0)).is_ok()
	assert ok<int, string>(0).@or(err<int, string>('')).is_ok()
	assert err<int, string>('').@or(ok<int, string>(0)).is_ok()
	assert err<int, string>('').@or(err<int, string>('')).is_err()

	// and
	assert ok<int, string>(0).and(ok<int, string>(0)).is_ok()
	assert ok<int, string>(0).and(err<int, string>('')).is_err()
	assert err<int, string>('').and(ok<int, string>(0)).is_err()
	assert err<int, string>('').and(err<int, string>('')).is_err()
}

fn test_result_native() {
	i := ok<int, int>(0).native() or {
		assert false, 'the native pass in the or block'
		2
	}
	assert i == 0

	j := err<int, int>(0).native() or {
		assert err.msg() == 'Err(0)'
		2
	}
	assert j == 2
}
