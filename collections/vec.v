module collections

import option { Maybe, some, noth }

struct Vec<T> {
pub mut:
	len u64
	arr &T = unsafe { voidptr(nil) }
}

pub fn new_vector<T>() Vec<T> {
	return Vec<T>{
		len: 0
	}
}

pub fn (mut v Vec<T>) push(item T) u64{
	unsafe {
		v.arr = C.realloc(v.arr, v.len + 1)
		v.arr[v.len] = item
	}
	return v.len++
}

pub fn (mut v Vec<T>) pop() &T {
	last_element := v.get(v.len - 1).unwrap()
	 unsafe {
		v.arr = C.realloc(v.arr, v.len - 1)
	}
	return &last_element
}

pub fn (v Vec<T>) get(i u64) Maybe<T> {
	if i >= v.len {
		return noth<T>()
	}
	return some<T>(unsafe{ v.arr[i] })
}

pub fn (v Vec<T>) iter() Iter<T> {
	return from_iterable<T>(v)
}
