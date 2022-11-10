module collections

fn test_vec() {
	mut vec := new_vector<int>()

	assert vec.get(0).is_noth()
	assert vec.cap == 0
	assert vec.len == 0

	vec.push(1)

	assert vec.get(0).is_some()
	assert vec.cap == 2
	assert vec.len == 1

	vec.push(1)
	vec.push(1)

	vec.insert(1, 3)

	assert vec.cap == 4
	assert vec.len == 4
	assert vec.get(1).is_some()
	assert vec.get(1).unwrap() == 3

	vec.shift()
	vec.delete(2)
	assert vec.cap == 4
	assert vec.len == 2
	assert vec.get(1).is_some()
	assert vec.get(1).unwrap() == 1
}

fn test_slice() {
	mut vec := new_vector<int>(9, 7, 0, 6)

	slice := vec.slice(start: 1, end: 3)
	assert slice.len == 2
	assert slice.get(0).unwrap() == 7
}

fn test_iter() {
	mut vec := new_vector<int>(1, 1, 1, 1)

	for i in vec.iter() {
		assert i == 1
	}
}
