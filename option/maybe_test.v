module option

fn test_maybe_booleans_operators() {
	// or
	assert some<int>(0).@or(some<int>(0)).is_some()
	assert some<int>(0).@or(noth<int>()).is_some()
	assert noth<int>().@or(some<int>(0)).is_some()
	assert noth<int>().@or(noth<int>()).is_noth()

	// and
	assert some<int>(0).and(some<int>(0)).is_some()
	assert some<int>(0).and(noth<int>()).is_noth()
	assert noth<int>().and(some<int>(0)).is_noth()
	assert noth<int>().and(noth<int>()).is_noth()
}

fn test_maybe_native() {
	i := some<int>(0).native() or {
		assert false, 'the native pass in the or block'
		2
	}
	assert i == 0

	j := noth<int>().native() or {
		assert err.msg() == ''
		2
	}
	assert j == 2
}
