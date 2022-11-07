module collections

import option { Maybe, noth, some }
import result { Result, err, ok }

pub enum VecError {
	out_of_range
}

pub struct Vec<T> {
	data_size u64
pub mut:
	data &T
	len  u64
	cap  u64
}

pub fn new_vector<T>() Vec<T> {
	return new_vector_with_cap<T>(0)
}

pub fn new_vector_with_cap<T>(cap u64) Vec<T> {
	data_size := sizeof(T)
	return Vec<T>{
		data_size: data_size
		data: C.calloc(cap, data_size)
		len: 0
		cap: cap
	}
}

fn (mut v Vec<T>) resize() {
	if v.cap == 0 {
		v.cap = 1
	}
	v.cap *= 2
	unsafe {
		v.data = C.realloc(v.data, v.cap * v.data_size)
	}
}

pub fn (mut v Vec<T>) push(item T) u64 {
	if v.len == v.cap {
		v.resize()
	}
	v.len++
	v.set(v.len - 1, item)
	return v.len - 1
}

pub fn (mut v Vec<T>) pop() Maybe<T> {
	last_element := v.get(v.len - 1)
	v.len--
	return last_element
}

pub fn (v Vec<T>) get(i u64) Maybe<T> {
	if i >= v.len {
		return noth<T>()
	}
	unsafe {
		return some<T>(v.data[i])
	}
}

pub fn (mut v Vec<T>) set(i u64, val T) Result<u8, VecError> {
	if i >= v.len {
		return err<u8, VecError>(VecError.out_of_range)
	}
	unsafe {
		v.data[i] = &val
	}
	return ok<u8, VecError>(0)
}

pub fn (v Vec<T>) iter() Iter<T> {
	return from_iterable<T>(v)
}

fn (v &Vec<T>) free() {
	unsafe {
		free(v.data)
		free(v)
	}
}
