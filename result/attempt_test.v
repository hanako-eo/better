module result

fn test_attempt_booleans_operators() {
	// or
	assert success<int>().@or(success<int>()).is_success()
	assert success<int>().@or(fail<int>(0)).is_success()
	assert fail<int>(0).@or(success<int>()).is_success()
	assert fail<int>(0).@or(fail<int>(0)).is_fail()

	// and
	assert success<int>().and(success<int>()).is_success()
	assert success<int>().and(fail<int>(0)).is_fail()
	assert fail<int>(0).and(success<int>()).is_fail()
	assert fail<int>(0).and(fail<int>(0)).is_fail()
}

fn test_attempt_native() {
	success<int>().native() or { assert false, 'the native pass in the or block' }

	fail<int>(0).native() or { assert err.msg() == 'Err(0)' }
}
